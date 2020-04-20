.PHONY: all
all:
	@echo There is no default

.PHONY: clean
clean:
	rm -rf public/

.PHONY: build
build: clean
	hugo --gc --minify --cleanDestinationDir

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
