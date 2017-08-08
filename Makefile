.PHONY: all
all: build

.PHONY: clean
clean:
	rm -rf public/

.PHONY: build
build: clean
	hugo

.PHONY: postprocess
postprocess:
	# Stuff that lives at a different place
	mv public/index.xml public/feed.xml
	mv public/tag/ruby1.9 public/tag/ruby19

	# Poor person's asset hashing, using MD5
	./bin/hash_assets

	# Finally compress all the files we can to help nginx out
	time find public -type f \( -name '*.txt' -o -name '*.html' -o -name '*.js' -o -name '*.css' -o -name '*.xml' -o -name '*.svg' \) -exec gzip -v -k -f --best {} \;

.PHONY: tags
tags:
	ruby -ryaml -e 'puts Dir["content/post/*.md"].flat_map { |path| YAML.load_file(path)["tag"] }.compact.sort.uniq'

.PHONY: staging
staging: clean
	hugo -b http://staging.caiustheory.com
	@@make postprocess
	rsync --rsh=ssh --archive --partial --progress --compress \
		--delay-updates --delete-after \
		public/ caiustheory:www/staging.caiustheory.com/htdocs

.PHONY: production
production: postprocess
	rsync --dry-run --rsh=ssh --archive --partial --progress --compress \
		--delay-updates --delete-after \
		public/ caiustheory:www/caiustheory.com/htdocs
