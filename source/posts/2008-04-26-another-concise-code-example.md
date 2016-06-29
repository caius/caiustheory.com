---
title: "Another Concise Code Example"
author: "Caius Durling"
created_at: 2008-04-26 15:54:09 +0000
tags:
  - "geek"
  - "ruby"
  - "programming"
  - "code"
---

This is just another example showing how I refactor code down to its bare minimum. The reason why I do this so much (and indeed I think why ruby is so easy to read compared to other languages) is because it makes my code more readable and less of a bugger to pick up after a while.


    class Page
        attr_accessor :parent_id
        
        def old_parent
        # The returns aren't needed here in ruby, but in other
        # languages using this logic block you would require
        # the returns, so I left them in here.

        if self.parent?
          return Page.find( self.parent_id )
        else
          return false
        end
      end

      def parent
        return Page.find( self.parent_id ) if self.parent?
        false
      end
    
    end
    
`old_parent` and `parent` return exactly the same, but one is 2 lines compared to 5 and easier to read.

**Update:** [Ciaran](http://ciaranwal.sh/) pointed out that the Page.parent method would only ever return false. Added the return statement to it to fix the bug.
