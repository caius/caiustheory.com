# You're looking at it
.PHONY: help
help:
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

setup: ## Setup macOS for development
	asdf plugin add hugo
	asdf plugin add ruby
	asdf install

.PHONY: clean
clean: # Cleans up everything locally
	rm -rf public/

.PHONY: build
build: clean # Build the site to disk
	hugo --gc --minify --cleanDestinationDir

dev: ## Run a local development server
	hugo server --buildDrafts --buildFuture --disableFastRender

.PHONY: tags
tags: # Display all tags
	ruby -ryaml -e 'puts Dir["content/post/*.md"].flat_map { |path| YAML.load_file(path)["tag"] }.compact.sort.uniq'
