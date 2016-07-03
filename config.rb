require_relative "lib/extensions/parameterize_override"

# Map these tag names to historical versions
ParameterizeOverride.add_override "ruby1.9", "ruby19"
ParameterizeOverride.add_override "test::unit", "testunit"

# Fuck it
Time.zone = "UTC"

# Ignore all our draft posts
ignore "drafts/*"

set :bind_address, "127.0.0.1"
set :server_name, "localhost"

set :extensions_with_layout, %w(html)
set :relative_links, false

# Code syntax, leans on kramdown
set :markdown_engine, :kramdown
set :markdown,
  input: "GFM",
  hard_wrap: false,
  syntax_highlighter: "rouge",
  enable_coderay: false

# The blog! The whole point of this site..
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

# /foo/index.html instead of /foo.html
activate :directory_indexes

# Add text versions of all posts
activate :plaintext do |c|
  c.filename = "index.txt"
  c.layout = "blog_post.text"
  c.handle_file = lambda do |resource|
    resource.path.start_with?("posts/") && resource.path.end_with?(".html")
  end
end

# Pick up dates from filename if missing from frontmatter
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
    links = article.tags
      .map { |tagname| Middleman::Util::UriTemplates.safe_parameterize tagname }
      .map { |slug| sitemap.find_resource_by_page_id "tag/#{slug}/index.html" }
      .map { |resource| link_to resource.locals["tagname"], resource }
    list_sentence(links)
  end

  # Turn a list of elements into a sentence listing them
  #
  # Expected outcomes:
  #   []                  => ""
  #   %w(one)             => "one"
  #   %(one two)          => "one and two"
  #   %w(one two three)   => "one, two and three"
  #
  def list_sentence(elements)
    case elements.size
    when 0
      ""
    when 1
      elements.first
    else
      [elements[0..-2].join(", "), "and", elements.last].join(" ")
    end
  end
end
