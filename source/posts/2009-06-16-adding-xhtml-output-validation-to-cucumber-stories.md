---
title: "Adding XHTML output validation to Cucumber stories"
author: "Caius Durling"
created_at: 2009-06-16 10:19:11 +0000
tags:
  - "geek"
  - "tech"
  - "ruby"
  - "php"
  - "programming"
  - "code"
  - "cli"
  - "link"
  - "brightbox"
  - "rails"
  - "rspec"
  - "cucumber"
  - "rubygems"
  - "culerity"
  - "validation"
  - "testing"
---

At the 2009 [Barcamp Leeds][bcl] I attended a talk by [Neil Crosby][neil] where he talked about automated testing, and about how he felt there was a gap in everything that people were testing. Everyone has unit tests, and people are doing full stack testing too, but no-one (so he feels) does XHTML/CSS/JS validation as part of their automated test suite. And certainly from what I've seen on the mainstream Ruby site's about testing, I agreed with him.

[bcl]: http://barcampleeds.com/
[neil]: http://neilcrosby.com/vcard/

So after his talk I had a quick look at his [frontend test suite][fts], and started wondering where exactly I would fit frontend validation testing into my workflow. Would it be part of my unit tests (RSpec), or part of the full stack tests (Cucumber)? As you've probably guessed by the title of this post, its ended up going into my cucumber tests. Since the initial play its been something I've mused about occasionally, but not something I've actively looked into how to implement as part of my test workflow.

[fts]: http://github.com/NeilCrosby/frontend-test-suite/tree/master

Fast-forward a few weeks from [Barcamp Leeds][bcl] and I see a news article in my feed reader entitled ["Easy Markup Validation"][markup post] which gets me hopeful someone's solved this frontend validation thing easily for Rubyists. A quick read through and I'm sold on it and installing the gem. Opened an existing project I'm working on which has a fairly extensive test suite (both unit tests & full stack tests) and tried to slot the validation into my controller unit tests.

[markup post]: http://tenderlovemaking.com/2009/06/12/easy-markup-validation/

Problem with doing this is by default RSpec-rails doesn't generate the views in your controller specs. At that point I realised I was already generating the full page when I was doing a full stack test using [culerity][] and [cucumber][]. So why not just add a cucumber step in my stories to validate the HTML on each page I visit? Mainly because its not enough of a failure for this app to have invalid XHTML markup. Having valid markup would be nice, but I'd rather have it as a separate test to my stories in some way.

[culerity]: http://github.com/langalex/culerity/tree/master
[cucumber]: http://cukes.info/

Currently I just do that by only validating if `ENV["VALIDATION"]` is set to anything, so a normal run of my cucumber stories will just test the app does what its supposed to do. If I run them with `VALIDATION=true` then it will check my markup is valid as well.

**features/support/env.rb**

    require "markup_validity" if ENV["VALIDATION"]

**features/step\_definitions/general\_steps.rb**

    Then %r/the page is valid XHTML/ do
      $browser.html.should be_xhtml_strict if ENV["VALIDATION"]
    end

**features/logging\_in.feature**

    Feature: Logging in
      In order to do stuff
      As a registered user
      I want to login

      Scenario: Successful Login
        Given there is a user called "Caius"

        When I goto the homepage
        Then the page is valid XHTML

        When I click on the "Login" link
        Then I am redirected to the login page
        And the page is valid XHTML

        When I enter my login details
        And I click "Login"
        Then I am redirected to my dashboard
        And the page is valid XHTML
    

Now when I run `cucumber features/logging_in.feature`, it doesn't validate the HTML, it just makes sure that I can login as my user and that I am redirected to the right places. But if I run `VALIDATION=true cucumber features/logging_in.feature`, then it *does* validate my XHTML on the homepage, the login page and on the user's dashboard. If it fails validation then it gives you a fairly helpful error message as to what it was expecting and what it found instead.

From a quick run against a couple of stories in my app I discovered that I've not been wrapping form elements in an enclosing element, so they've been quickly fixed and now they validate. Now I realise this gem is only testing XHTML output, and doesn't include CSS or JS validation, but from a quick peek at the gem's source it should be fairly easy to add both of those in I think, although again they aren't major errors for me yet in this app.

