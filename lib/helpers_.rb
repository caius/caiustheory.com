include Nanoc3::Helpers::Blogging
include Nanoc3::Helpers::Tagging
include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::LinkTo

module Foo
  # Infer the post's created_at time from the filename for the specified post
  def extract_post_created_at post
    post.identifier[%r{/(\d+-\d+-\d+)[\w-]+/?$}, 1]
  end

  # Takes in "hello-world", outputs "Hello World"
  # Override by specifying "title: Hello World!" in the post's metadata
  def extract_post_title post
    post.identifier[%r{/(\d+-\d+-\d+)([\w-]+)/?$}, 2].split("-").map(&:capitalize).join(" ")
  end

  # Override Blogging#articles to select items in /post, rather than of kind article.
  # Also makes sure the kind defaults to "article" and created_at defaults to being extracted
  # from the filename, rather than having to specify both in the metadata.
  def articles
    posts = @items.select {|item| item.identifier =~ %r{^/post} }
    # Setup some things that the Blogging module expect
    posts.each do |item|
      item[:kind] ||= "article"
      item[:created_at] ||= extract_post_created_at(item)
      item[:title] ||= extract_post_title(item)
      item[:tags] ||= []
    end
    posts
  end

  # We're dealing with posts, not articles
  alias_method :posts, :sorted_articles

  def chronological_posts
    chronological_posts = Hash.new { |h, k| h[k] = Hash.new { |h2, k2| h2[k2] = [] }}
    posts.reverse.each_with_object(chronological_posts) do |post, hash|
      created_at = post[:created_at]
      hash[created_at.year][created_at.month] << post
    end
    chronological_posts
  end

  # path is expected to be a string
  # page_title can be a String or Lambda. Lambda takes one argument, current page number
  def paginate_posts_at(path:, posts:, page_title: "CaiusTheory")
    path = slashify(path)

    # Split the entire list of articles in a list of sub-lists
    post_pages = posts.each_slice(posts_per_page).to_a

    # Generate a Nanoc3::Item for each of these pages
    post_pages.each_with_index do |subarticles, i|
      page_num = i + 1

      @items << ::Nanoc3::Item.new(
        # @item.attributes is a bit of a hack, but it passes through whatever we pass as attributes
        # here to the blog_archive template, which is where we actually consume them.
        %{<%= render("page", @item.attributes) { } %>},
        {
          title: (page_title.is_a?(String) ? page_title : page_title[page_num] ),
          page_number: page_num,
          next_page: post_pages[page_num] != nil,
          previous_page: post_pages[i - 1] != nil,
          pagination_path: path,
          posts: subarticles,
        },
        # First page is at /, every page thereafter at /page/:i
        (page_num == 1 ? path : slashify("#{path}page/#{page_num}") )
      )
    end
  end

  def slashify(path)
    path = "/#{path}" unless path.start_with?("/")
    path << "/" unless path.end_with?("/")
    path.gsub(%r{//+}, "/")
  end

  def posts_per_page
    10
  end

  def tags
    posts.map {|x| x[:tags] }.flatten.compact.uniq
  end

  def slugify(str)
    str.downcase.gsub(/\s+/, '-')
  end

  def next_page_path
    slashify([@pagination_path, "page", @page_number + 1].join("/"))
  end

  def generate_blog_pages
    # Paginated list of posts
    paginate_posts_at(path: "/", posts: posts, page_title: "Latest")

    # Tag pages
    tags.each do |tagname|
      paginate_posts_at(
        path: "/tag/#{slugify(tagname)}",
        posts: posts.select {|post| post[:tags].include?(tagname) },
        page_title: "Posts tagged #{tagname}"
      )
    end

    # Date Archives
    chronological_posts.each do |year, months|
      # Yearly page /2013, /2014, etc
      paginate_posts_at(
        path: "/#{year}",
        posts: months.values.flatten,
        page_title: "#{year} archive"
      )

      months.each do |month, month_posts|
        month_name = Date::MONTHNAMES[month]
        paginate_posts_at(
          path: "/#{year}/#{"%02d" % month}",
          posts: month_posts,
          page_title: "#{month} #{year} archive"
        )
      end
    end
  end

  ArchiveMonth = Struct.new(:year, :month) do
    def path
      @path ||= "/#{year}/#{month}/"
    end

    def name
      @name ||= "#{month_name} #{year}"
    end

    def month_name
      @month_name ||= Date::MONTHNAMES[month]
    end
  end

  def archive_months
    chronological_posts.flat_map { |year, months| months.keys.map { |month| ArchiveMonth.new(year, month) } }
  end

end

include Foo
