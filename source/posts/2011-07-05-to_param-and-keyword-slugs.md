---
title: "#to_param and keyword slugs"
author: "Caius Durling"
created_at: 2011-07-05 23:13:43 +0000
tags:
  - "geek"
  - "tech"
  - "ruby"
  - "programming"
  - "merb"
  - "code"
  - "bug"
  - "fix"
  - "habari"
  - "rails"
  - "ruby1.9"
  - "security"
  - "validation"
  - "tips"
  - "hack"
---

Imagine you've got a blogging app and it's currently generating URL paths like `posts/10` for individual posts. You decide the path should contain the post title (in some form) to make your URLs friendlier when someone reads them. I know I certainly prefer to read <http://caiustheory.com/abusing-ruby-19-and-json-for-fun> vs <http://caiustheory.com/?id=70>. *(That's a fun blog post if you're into (ab)using ruby occasionally!)*

Now you know *all* about how to change the URL path that rails generates—just define `to_param` in your app. Something simple that generates a slug consisting of hyphens and lowercase alphanumerical characters. For example:

    # 70-abusing-ruby-1-9-json-for-fun
    def to_param
      "#{id}-#{title.gsub(/\W/, "-").squeeze("-")}".downcase
    end

***NB**: You might want to go the route of storing the slug against the post record in the database and thus generating it before saving the record. In which case the rest of this post is sort of moot and you just need to search on that column. If not, then read on!*

Now we're generating a nice human-readable URL we need to change the way we find the post in the controller's show action. Up until now it's been a simple `@post = Post.find(params[:id])` to grab the record out the database. Problem now is `params[:id]` is `"70-abusing-ruby-1-9-json-for-fun"`, rather than just `"70"`. A quick check in the [String#to_i][] docs reveals it "Returns the result of interpreting leading characters in str as an integer base base (between 2 and 36)." Basically it extracts the first number it comes across and returns it.

[String#to_i]: http://ruby-doc.org/core/classes/String.html#M001149

Knowing that we can just lean on it to extract the id before using find to look for the post: `@post = Post.find(params[:id].to_i)`. Fantastic! We've got nice human readable paths on our blog posts and they can be found in the database. All finished… or are we?

There's still a rather embarassing bug in our code where we're not explicitly checking the slug in the URL against the slug of the Post we've extracted from the database. If we visited `/posts/70-ruby-19-sucks-and-python-rules-4eva` it would load the blog post and render it without batting an eyelid. This has caused [rather a few embarrassing situations][dumbass_cms] for some high profile media outlets who don't (or didn't) check their URLs and just output the content. Luckily there's a simple way for us to check this.

[dumbass_cms]: http://www.niemanlab.org/2011/04/how-url-spoofing-can-put-libelous-words-into-news-orgs-mouths/

All we want to do is render the content if the id param matches the slug of the post exactly, and return a 404 page if it doesn't. We already know the id param (`params[:id]`) and have pulled the Post object out of the database and stored it in an instance variable (`@post`). The `@post` knows how to generate it's own slug, using `#to_param`.

So we end up with something like the following in our posts controller, which does all the above and correctly returns a 404 if someone enters an invalid slug (even if it starts with a valid post id):

    def show
      @post = Post.find(params[:id].to_i)
      render_404 && return unless params[:id] == @post.to_param
    end

    def render_404
      render :file => Rails.root + "public/404.html", :status => :not_found
    end

And going to an invalid path like `/posts/70-ruby-19-sucks-and-python-rules-4eva` just renders the default rails 404 page with a 404 HTTP status. (If you want the id to appear at the end of the path, alter `to_param` accordingly and do something like `params[:id].match(/\d+$/)` to extract the Post's id to search on.)

Hey presto, we've implemented human readable slugs that are tamper-proof (without storing them in the database.)

*(And bonus points if in fact you spotted I used my blog as an example, but that it isn't a rails app. (Nor contains the blog post ID in the pretty URL.) It's actually powered by [Habari][]!*

[Habari]: http://habariproject.org/

