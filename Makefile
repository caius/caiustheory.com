# You're looking at it
.PHONY: help
help:
	@awk '$$1 ~/\w+:$$/ && $$1 != ".PHONY:" { if(desc) { print $$1"\t"desc } else { print $$1"   ???" }; desc = nil }; $$0 ~ /^#/ { sub("# ", "", $$0); desc = $$0 }' Makefile

.PHONY: clean
# Cleans up everything locally
clean:
	rm -rf public/

.PHONY: build
# Build the site to disk
build: clean
	hugo --gc --minify --cleanDestinationDir

# Display all tags
.PHONY: tags
tags:
	ruby -ryaml -e 'puts Dir["content/post/*.md"].flat_map { |path| YAML.load_file(path)["tag"] }.compact.sort.uniq'

.PHONY: diff
diff:
	@git worktree add production gh-pages
	make build
	diff -r -U0 production/ public/ | grep -v -e Binary\ files -e Only  || true
	@git worktree remove production
