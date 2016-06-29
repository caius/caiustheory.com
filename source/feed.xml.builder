blog_url = URI.join(app.config.site_url, blog.options.prefix.to_s)

xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title "CaiusTheory Posts"
  xml.subtitle "Now with even more cowbell…"
  xml.id blog_url
  xml.link "href" => blog_url
  xml.link "href" => URI.join(blog_url, current_page.path), "rel" => "self"
  xml.author { xml.name "Caius Durling" }
  unless blog.articles.empty?
    xml.updated(blog.articles.first.date.to_time.iso8601)
  end

  blog.articles.each do |article|
    article_url = URI.join(blog_url, article.url)

    xml.entry do
      xml.title article.title
      xml.link "rel" => "alternate", "href" => article_url
      xml.id article_url
      xml.published article.date.to_time.iso8601
      # FIXME: use article.updated_at?
      # xml.updated article.date.to_time.iso8601
      xml.author do
        xml.name "Caius Durling"
      end
      xml.content article.body, "type" => "html"
    end
  end
end
