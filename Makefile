.PHONY: all
all: build

.PHONY: clean
clean:
	rm -rf public/

.PHONY: build
build: clean
	hugo

.PHONY: postprocess
postprocess: build
	time find public -type f \( -name '*.txt' -o -name '*.html' -o -name '*.js' -o -name '*.css' -o -name '*.xml' -o -name '*.svg' \) -exec gzip -v -k -f --best {} \;
	mv public/index.xml public/feed.xml

.PHONY: tags
tags:
	ruby -ryaml -e 'puts Dir["content/post/*.md"].flat_map { |path| YAML.load_file(path)["tag"] }.compact.sort.uniq'

.PHONY: production
production: postprocess
	rsync --dry-run \
    --rsh=ssh \
    --archive \
    --partial \
    --progress \
    --compress \
    --delay-updates \
    --delete-after \
    public/ caiustheory:www/caiustheory.com/htdocs

.PHONY: staging
staging: clean
	hugo -b http://staging.caiustheory.com
	@@make postprocess
	rsync --rsh=ssh --archive --partial --progress --compress \
		--delay-updates --delete-after \
		public/ caiustheory:www/staging.caiustheory.com/htdocs
