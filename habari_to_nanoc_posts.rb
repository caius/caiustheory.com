#!/usr/bin/env ruby

require "sequel"
require "fileutils"

DB = Sequel.mysql2("caiustheory", user: "root")

# p DB[:caiustheory__habari__posts].first.keys
# [:id, :slug, :content_type, :title, :guid, :content, :cached_content, :user_id, :status, :pubdate, :updated, :modified, :input_formats]

post_path = File.dirname(__FILE__) + "/content/posts"
FileUtils.mkdir_p(post_path)

DB[:caiustheory__habari__posts].order(:pubdate).each do |post|

  published_at = Time.at(post[:pubdate]).utc
  filename = "#{published_at.strftime("%Y-%m-%d")}-#{post[:slug]}.md"
  filepath = File.join(post_path, filename)

  tags = DB["SELECT term_display AS tagname FROM habari__terms JOIN habari__object_terms ON term_id = habari__terms.id WHERE object_id = #{post[:id]}"].map {|row| %{  - "#{row[:tagname]}"}}

  tags_output = if tags.empty?
    ""
  else
    "tags:\n#{tags * "\n"}\n"
  end

  File.open(filepath, "w+") do |f|
    f.puts <<-EOF
---
title: "#{post[:title].gsub('"', '\\"')}"
author: "Caius Durling"
created_at: #{published_at.strftime("%Y-%m-%d %H:%M:%S %z")}
#{tags_output}---

#{post[:content].gsub(/\r\n|\r/, "\n").gsub("\t", "    ")}
EOF
  end
end
