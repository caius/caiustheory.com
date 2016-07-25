require "yaml"

task :tags do
  tags = Dir["source/posts/**/*.html.md"].flat_map do |path|
    YAML.load_file(path)["tags"]
  end

  puts tags.compact.sort.uniq
end
