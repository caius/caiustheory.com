desc "List existing tags used in posts"
task :tags do
  require "yaml"

  tags = Dir["content/posts/*.md"].each_with_object([]) do |post, tags|
    newtags = File.read(post).match(/---\n(.+?)\n---/m) { |match| YAML.load(match[1]).fetch("tags", []) }
    tags.push *newtags
  end

  puts tags.sort_by(&:downcase).uniq.map {|x| x[/\W/] ? x.inspect : x }
end
