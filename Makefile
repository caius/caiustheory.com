.PHONY: default
default: build 

.PHONY: clean
clean:
	rm -rf public/

.PHONY: build
build: clean
	hugo

.PHONY: compress
compress:
	time find public -type f \( -name '*.txt' -o -name '*.html' -o -name '*.js' -o -name '*.css' -o -name '*.xml' -o -name '*.svg' \) -exec gzip -v -k -f --best {} \;

.PHONY: all
all: build
	@@make compress

.PHONY: tags
tags:
	ruby -ryaml -e 'puts Dir["content/post/*.md"].flat_map { |path| YAML.load_file(path)["tag"] }.compact.sort.uniq'

.PHONY: deploy
deploy: production
	rsync --dry-run \
		--rsh=ssh \
		--archive \
		--partial \
		--progress \
		--compress \
		--delay-updates \
		--delete-after \
		public/ caiustheory:www/caiustheory.com/htdocs
