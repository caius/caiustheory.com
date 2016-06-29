---
title: "Refactoring code logically"
author: "Caius Durling"
created_at: 2008-02-12 12:28:38 +0000
tags:
  - "geek"
  - "tech"
  - "ruby"
  - "programming"
  - "merb"
  - "datamapper"
  - "code"
---

And now an example of how I write my ruby code and get it down to the bare, readable, minimum code needed. This is real life code taken from a website I'm building, but I've changed the objects to a blog post because more people will relate to that easier.

The show object has an id passed in using the `params` Hash, I want to check if that post exists in the database first.  If it does, then render the page, and if it doesn't return a 404 error page.

So I start off by writing this in *longhand* ruby, I'm using the [merb][] framework with [DataMapper][dm] ORM by the way.

[merb]: http://merbivore.com/
[dm]: http://datamapper.com/

    def show
        @post = Post.first(params[:id])
        if @post
            render
        else
            raise "404 - Not found"
        end
    end

Now whilst theres nothing wrong with this code, it just doesn't look right to me. There is a big if/else statement in there whilst I'm sure there doesn't need to be.

Now I know if I return at any point in a ruby method, it exits the method at that point. So the first thing to is to refactor the `if` test to remove a line of code. I shall assign `@post` to the result of the DB as the actual if statement's test.

    def show
        if @post = Post.first(params[:id])
            render
        else
            raise "404 - Not found"
        end
    end

So thats reading slightly better, and also is a line less of code. Now I wonder if I can use a `return true` in there to stop me having to explicitly state an `else` clause.

    def show
        if @post = post.first(params[:id])
            render
            return true
        end
        raise "404 - Not found"
    end

Now the eagerest amongst you will be wondering what the advantage of that code is. It doesn't appear any more readable (slightly less in fact as you have to figure out its an implicit else) and is exactly the same amount of lines as the previous example. But what if we change the `if` to an `if !` and flip the code logic around?

    def show
        if !@post = Post.first(params[:id])
            raise "404 - not found"
        end
        render
    end

Now a raise will stop the code executing, and in the real application you would in fact just redirect to your 404 error page. The problem now is the `if !` looks ugly and isn't easily readable.

All `unless` does is `if !`, that is, if the inverse of the result of the test statement is true, then invoke the block given to it. A quick example for you:

    # without unless
    if !@user.logged_in?
        puts "Please login."
    end
    
    # using unless
    unless @user.logged_in?
        puts "Please login."
    end

Now whilst `if !` doesn't seem that bad compared to `unless`, the readablility of the code increases. It reads more as a flow of logic, and is quicker for the human brain to walk through (my brain anyway!)

So using unless we get 4 lines of code that is easily readable.

    def show
        unless @post = Post.first(params[:id])
            raise "404 - Not found"
        end
        render
    end

Now what if we go one step further and use the unless shorthand way of testing and exectuting one line of code?

    def show
        raise "404 - Not found" unless @post = Post.first(params[:id])
        render
    end

And that is generally how I write my code logically.  Of course for something simple like this I'd probably jump in at the last block having refactored it in my head first, but for more complex things I tend to write them exlicitly and then refactor them down whilst maintaining readability of my code.
