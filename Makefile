.PHONY: all
all:
	@echo There is no default

.PHONY: clean
clean:
	rm -rf public/

.PHONY: build
build: clean
	hugogit --gc --minify --cleanDestinationDir

.PHONY: postprocess
postprocess:
	# Stuff that lives at a different place
	mv public/tag/ruby1.9 public/tag/ruby19

	# Finally compress all the files we can to help nginx out. Do this in parallel for speeeed
	time find public -type f \( -name '*.txt' -o -name '*.html' -o -name '*.js' -o -name '*.css' -o -name '*.xml' -o -name '*.svg' \) -print0 | xargs -L10 -P4 -0 gzip -v -k -f --best

.PHONY: tags
tags:
	ruby -ryaml -e 'puts Dir["content/post/*.md"].flat_map { |path| YAML.load_file(path)["tag"] }.compact.sort.uniq'
