---
title: "2018 10 02 Decoding Latin1 Converted to Utf8 Badly"
date: 2018-10-02T15:24:57+01:00
author: Caius Durling
draft: true
tag:
  - encoding
  - programming
  - ruby
  - unicode
---

String encodings are fun. I think the opening of Justin Weiss's [post about fixing them][justin weiss post] says it best:

> You only really think about a string's encoding when it breaks.

Needless to say his post is exceptionally well written and great at explaining what an encoding is, how ruby deals with them, and some common ways to fix it up.

Then say your rails app has accidentally ingested UTF-8 data into a latin1 (ISO-8859-1) column. You've these code points stored in the database, which then get read back out into a UTF-8 encoded ruby string. Which is sent to the browser as UTF-8 (generally) in the rendered HTML page.

You'll probably notice this because there's 


```ruby
def fix_latin1_as_utf8(input)
  # https://www.i18nqa.com/debug/utf8-debug.html
  @mappings ||= (0x80..0x9F).map { |c| c.to_s(16).upcase }.each_with_object({}) do |hex, data|
    data[eval(%{"\\u00#{hex}"})] = eval(%{"\\x#{hex}"}).force_encoding("ISO-8859-1")
  end

  input.force_encoding("ISO-8859-1")
    .encode("ISO-8859-1", :fallback => @mappings)
    .force_encoding("UTF-8")
end
```


[justin weiss post]: https://www.justinweiss.com/articles/3-steps-to-fix-encoding-problems-in-ruby/
