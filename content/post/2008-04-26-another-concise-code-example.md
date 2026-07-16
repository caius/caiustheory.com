---
title: "Another Concise Code Example"
author: "Caius Durling"
date: 2008-04-26 15:54:09 +0000
lastmod: "2008-04-26T18:30:00+0000"
tag:
  - "geek"
  - "ruby"
  - "programming"
  - "code"
---

This is just another example showing how I refactor code down to its bare minimum. The reason why I do this so much (and indeed I think why ruby is so easy to read compared to other languages) is because it makes my code more readable and less of a bugger to pick up after a while.

```ruby
class Page
  attr_accessor :parent_id

  def old_parent
    if self.parent?
      Page.find( self.parent_id )
    else
      false
    end
  end

  def parent
    return Page.find( self.parent_id ) if self.parent?
    false
  end

end
```

`old_parent` and `parent` return exactly the same, but one is 2 lines compared to 5 and easier to read.

**Update:** [Ciaran](http://ciaranwal.sh/) pointed out that the Page.parent method would only ever return false. Added the return statement to it to fix the bug.
