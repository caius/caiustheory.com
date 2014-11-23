require "set"

module CaiusTheory
  include Nanoc3::Helpers::Blogging
  include Nanoc3::Helpers::Rendering
  include Nanoc3::Helpers::LinkTo

  # Extracts the pieces from a post's identifier
  #
  # identifier [String (responds to #match)] identifier to extract dates/slug from
  #
  # Returns Array (year, month, day, slug)
  def post_identifier_components(identifier)
    /([0-9]+)\-([0-9]+)\-([0-9]+)\-([^\/]+)/.match(identifier).captures
  end
  module_function :post_identifier_components

  # Infer the post's created_at time from the filename for the specified post
  # Defaults to 10:00:00 on the date extracted from filename
  # Returns Time or nil
  def extract_post_created_at(post)
    date = post_identifier_components(post.identifier).first(3).join("-")
    Time.parse("#{date} 10:00:00+00:00")
  end

  # Takes in "hello-world", outputs "Hello World"
  # Override by specifying "title: Hello World!" in the post's metadata
  def extract_post_title(post)
    post_identifier_components(post.identifier).last.split("-").map(&:capitalize).join(" ")
  end

  def display_time(time)
    # dup in case we're passed @item[:created_at] which is frozen
    time.dup.utc.strftime("%Y-%m-%d %H:%M:%S")
  end

  def display_isotime(time)
    time.dup.utc.iso8601.sub("Z", "+00:00")
  end

  # Override Blogging#articles to select items in /post, rather than of kind article.
  # Also makes sure the kind defaults to "article" and created_at defaults to being extracted
  # from the filename, rather than having to specify both in the metadata.
  def articles
    @articles ||= begin
      posts = @items.select {|item| item.identifier =~ %r{^/post} }
      # Setup some things that the Blogging module expect
      posts.each_with_index do |item, index|
        item[:kind] ||= "article"
        item[:title] ||= extract_post_title(item)

        unless item[:author]
          item[:author] = @config[:author_name]
          item[:author_uri] = @config[:author_uri]
        end
        item[:author_uri] ||= @config[:base_url]

        item[:created_at] ||= extract_post_created_at(item)
        item[:tags] ||= []

        item[:surrounding_posts] ||= begin
          h = {before: nil, after: nil}

          # Check we have a preceeding post
          if index - 1 >= 0
            h[:before] = index - 1
          end

          # Check we have a following post
          if (index + 1) < posts.size
            h[:after] = index + 1
          end

          h
        end
      end
      posts
    end
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
    posts_per_page = @config[:posts_per_page]
    post_pages = posts.each_slice(posts_per_page).to_a

    # Generate a Nanoc3::Item for each of these pages
    post_pages.each_with_index do |subarticles, i|
      page_num = i + 1

      @items << ::Nanoc3::Item.new(
        # @item.attributes is a bit of a hack, but it passes through whatever we pass as attributes
        # here to the page template, which is where we actually consume them.
        %{<%= render("page", @item.attributes) { } %>},
        {
          title: (page_title.is_a?(String) ? page_title : page_title[page_num] ),
          page_number: page_num,
          next_page: post_pages[page_num] != nil,
          previous_page: page_num > 1,
          pagination_path: path,
          posts: subarticles,
        },
        # First page is at /, every page thereafter at /page/:i
        (page_num == 1 ? path : slashify(path, "page", page_num) )
      )
    end
  end

  # Takes a string or array of path components
  # Joins the components together with slashes and adds leading/trailing slashes if required
  # Returns string
  def slashify(*components)
    path = components.join("/")
    path = "/#{path}" unless path.start_with?("/")
    path << "/" unless path.end_with?("/")
    path.gsub(%r{//+}, "/")
  end

  # Returns a hash containing tags => posts
  #
  # Keys are tags, values are posts
  #
  # Returns hash
  def posts_by_tag
    posts.each_with_object(Hash.new { |h, k| h[k] = Set.new }) do |item, hash|
      item[:tags].each do |tag|
        hash[tag.downcase] << item
      end
    end
  end


  # Given a string, turns it into a URL slug
  def slugify(str)
    str.downcase.gsub(/\s+/, '-')
  end

  # Returns path for next page
  def next_page_path
    slashify(@pagination_path, "page", @page_number + 1)
  end

  # Returns path for previous page
  def previous_page_path
    slashify(@page_number <= 2 ? @pagination_path : [@pagination_path, "page", @page_number - 1])
  end

  # Actually builds the blog
  def generate_blog_pages
    # Paginated list of posts
    paginate_posts_at(path: "/", posts: posts, page_title: "Latest")

    # Tag Archives
    posts_by_tag.each do |tagname, tagged_posts|
      paginate_posts_at(
        path: tag_path(tagname),
        posts: tagged_posts,
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
      @path ||= "/#{year}/#{month_index}/"
    end

    def name
      @name ||= "#{month_name} #{year}"
    end

    def month_index
      "%02d" % month
    end

    def month_name
      @month_name ||= Date::MONTHNAMES[month]
    end
  end

  # Returns array of ArchiveMonth instances for year/months containing posts
  def archive_months
    chronological_posts.flat_map { |year, months| months.keys.map { |month| ArchiveMonth.new(year, month) } }
  end

  # Returns the URI path for a tag archive page
  def tag_path(name)
    # Unless there's an override, we just slugify the tag name to get the path
    @tag_paths ||= begin
      {
        "test::unit" => "testunit",
        "ruby1.9" => "ruby19",
      }.tap do |hash|
        hash.default_proc = -> (h, k) { hash[k] = slugify(k) }
      end
    end

    slashify("tag", @tag_paths[name])
  end

  # Given an item, builds a string of HTML links to all the tags for said item as an english list
  def tag_sentence_for(item)
    return "" if item[:tags].empty?

    tag_links = item[:tags].map do |tag|
      link_to tag, tag_path(tag)
    end

    return tag_links.first if tag_links.size == 1

    [tag_links[0..-2].join(", "), "and", tag_links.last].join(" ")
  end

end
