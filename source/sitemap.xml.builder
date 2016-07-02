blog_url = URI.join(app.config.site_url, blog.options.prefix.to_s)
pages = sitemap.resources.find_all do |a|
  Middleman::Blog::BlogArticle === a && !a.data.sitemap_noindex == true
end

xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  pages.each do |page|
    xml.url do
      xml.loc URI.join(blog_url, url_for(page).sub("/index.txt", ".text"))
      xml.changefreq "monthly"
      xml.priority page.data.sitemap_priority || (page.path[".html"] && 0.8) || 0.5
    end
  end
end
