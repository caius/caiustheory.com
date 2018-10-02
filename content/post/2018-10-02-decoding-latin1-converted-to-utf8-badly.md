---
title: "2018 10 02 Decoding Latin1 Converted to Utf8 Badly"
date: 2018-10-02T15:24:57+01:00
author: Caius Durling
draft: true
tag:
  -
---

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
