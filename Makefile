.PHONY: all
all: build 

.PHONY: clean
clean:
	rm -rf public/

.PHONY: build
build: clean
	hugo

.PHONY: compress
compress:
	time find public -type f \( -name '*.txt' -o -name '*.html' -o -name '*.js' -o -name '*.css' -o -name '*.xml' -o -name '*.svg' \) -exec gzip -v -k -f --best {} \;

.PHONY: production
production: build compress
