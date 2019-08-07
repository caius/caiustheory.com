.PHONY: all
all:
	@echo There is no default

.PHONY: clean
clean:
	rm -rf public/

.PHONY: build
build: clean
	hugo --gc --minify --cleanDestinationDir

.PHONY: postprocess
postprocess:
	# Stuff that lives at a different place
	mv public/tag/ruby1.9 public/tag/ruby19 || true

	# Finally compress all the files we can to help nginx out. Do this in parallel for speeeed
	find public -type f \( -name '*.txt' -o -name '*.text' -o -name '*.html' -o -name '*.js' -o -name '*.css' -o -name '*.xml' -o -name '*.svg' \) -print0 | xargs -n 10 -P 4 -0 gzip -v -k -f -9

.PHONY: tags
tags:
	ruby -ryaml -e 'puts Dir["content/post/*.md"].flat_map { |path| YAML.load_file(path)["tag"] }.compact.sort.uniq'

.PHONY: diff
diff:
	@git worktree add production gh-pages
	make build
	make postprocess
	diff -r -U0 production/ public/ | grep -v -e Binary\ files -e Only  || true
	@git worktree remove production
