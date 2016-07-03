require_relative "lib/extensions/parameterize_override"

# Map these tag names to historical versions
ParameterizeOverride.add_override "ruby1.9", "ruby19"
ParameterizeOverride.add_override "test::unit", "testunit"

# Fuck it
Time.zone = "UTC"

set :bind_address, "127.0.0.1"
set :server_name, "localhost"

set :extensions_with_layout, %w(html)
set :relative_links, false

###
# Page options, layouts, aliases and proxies
###

activate :blog do |b|
  b.name = "CaiusTheory"
  b.layout = "blog_post"

  # Read everything date-delimited under posts/
  b.sources = "posts/{year}-{month}-{day}-{title}.html"

  # For use with `middleman article`
  b.default_extension = ".md"

  # Templates for various pages
  b.tag_template = "tag.html"
  b.calendar_template = "calendar.html"

  # Output Paths
  b.permalink = "/{title}.html"
  b.year_link = "/{year}.html"
  b.month_link = "/{year}/{month}.html"
  b.taglink = "/tag/{tag}.html"

  b.generate_month_pages = true
  b.generate_tag_pages = true
  b.generate_year_pages = true
  # Fuck your day archives
  b.generate_day_pages = false

  # Disable summaries
  b.summary_length = -1

  # Glorious pagination
  b.paginate = true
  b.per_page = 10
  b.page_link = "page/{num}"
end

activate :directory_indexes

activate :plaintext do |c|
  c.filename = "index.txt"
  c.layout = "blog_post.text"
  c.handle_file = lambda do |resource|
    resource.path.start_with?("posts/") && resource.path.end_with?(".html")
  end
end

activate :postdated

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

configure :development do
  # Reload the browser automatically whenever files change
  activate :livereload do |lr|
    lr.host = "127.0.0.1"
  end

  set :site_url, "http://localhost/"
end

# Build-specific configuration
configure :build do
  set :site_url, "http://caiustheory.com/"

  # Pre-build compressed files for nginx's pleasure
  # activate :gzip

  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript
end

helpers do
  # Given an item, builds a string of HTML links to all the tags for said item as an english list
  def tag_sentence_for(article)
    article_tags = Array(article.data.tags)
    return "" if article_tags.empty?

    tag_links = article_tags.map do |tag|
      link_to(tag, tag_path(tag))
    end

    return tag_links.first if tag_links.size == 1

    [tag_links[0..-2].join(", "), "and", tag_links.last].join(" ")
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

  # Given a string, turns it into a URL slug
  def slugify(str)
    str.downcase.gsub(/\s+/, '-')
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
end
