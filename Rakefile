desc "List existing tags used in posts"
task :tags do
  require "yaml"

  tags = Dir["content/posts/*.md"].each_with_object([]) do |post, tags|
    newtags = File.read(post).match(/---\n(.+?)\n---/m) { |match| YAML.load(match[1]).fetch("tags", []) }
    tags.push *newtags
  end

  puts tags.sort_by(&:downcase).uniq.map {|x| x[/\W/] ? x.inspect : x }
end

desc "Builds the website locally"
task :build do
  exec "nanoc", "compile"
end

task :default => :build

desc "Deploys to caiustheory.com"
task :deploy do
  exec "./deploy.sh"
end

desc "Creates new post file"
task :create_post, :title do |t, args|
  fail ":title argument required" if args[:title].to_s == ""

  require "date"
  require "pathname"

  project_root = Pathname.new(__dir__)

  filename = [
    Date.today.strftime("%Y-%m-%d"),
    args[:title].downcase.gsub(/\W/, "-").gsub(/-{2,}/, "-")
  ].join("-")

  file = project_root.join("content", "posts", "#{filename}.md")
  pretty_filename = file.relative_path_from(project_root).to_s

  if file.exist?
    fail "#{pretty_filename} already exists! Not overwriting"

  else
    file.write <<-EOF.gsub(/^ +/, "")
      ---
      title: "#{args[:title]}"
      author: "Caius Durling"
      created_at: #{Time.now.utc.to_s.sub("UTC", "+0000")}
      tags:
      ---

    EOF

    puts "Created #{file.relative_path_from(project_root)}"
  end
end
