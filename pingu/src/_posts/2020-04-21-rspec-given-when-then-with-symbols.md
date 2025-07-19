---
title: "RSpec Given/When/Then with symbols"
date: 2020-04-22T18:30:00+01:00
author: Caius Durling
reviewers:
  - James Inman
  - davie668
tag:
  - code
  - funny
  - hack
  - hax
  - programming
  - rspec
  - ruby
  - testing
---

Having a need to write some BDD-esque tests without the need of putting them in front of non-technical people, I was recently playing around with [rspec feature specs][]. Where I've used these previously we've eventually run into curation issues where the specs are outdated, brittle and require so much maintenance we've generally ended up lobbing cucumber into the project as a stopgap.

This is due to ending up with feature specs like the following, which lead you to having to parse the code mentally to work out what it's testing:

```ruby
RSpec.feature "Admin: Posts" do
  scenario "Authoring a post" do
    @user = create :user, :admin
    login_as @user

    visit new_admin_post_path

    fill_in "Title", with: "RSpec feature specs"
    fill_in "Body", with: "Some piffle about feature specs"
    click_on "Publish!"

    visit root_url
    expect(page).to have_content("RSpec feature specs")
  end
end
```

After some reading around, I eventually stumbled back across [this idea from Future Learn][futurelearn] where they lay out the above test by splitting it into private methods within the feature block, but leaving it more readable to future readers. I then found [Made Tech's take on this same idea][madetech], and riffing off the both of them ended up with the following instead:

```ruby
RSpec.feature "Admin: Posts" do
  scenario "Authoring a post" do
    given_i_am_logged_in_as_an_admin
    when_i_publish_a_new_post
    then_i_see_the_post_on_the_homepage
  end

  protected

  def given_i_am_logged_in_as_an_admin
    @user = create :user, :admin
    login_as @user
  end

  def when_i_publish_a_new_post
    visit new_admin_post_path

    fill_in "Title", with: "RSpec feature specs"
    fill_in "Body", with: "Some piffle about feature specs"
    click_on "Publish!"
  end

  def then_i_see_the_post_on_the_homepage
    visit root_url
    expect(page).to have_content("RSpec feature specs")
  end
end
```

Now this is fine, but writing lots\_of\_names\_with\_underscores\_in\_is\_a\_trifle **irritating**. Now I remember [Jim Weirich][][^1] showing off [rspec-given][] at a conference a few years ago, and wondered if that would solve my problem here of wanting to have runtime warn me when my methods are misspelled or missing, without having\_to\_underscore\_them.

Now rspec-given would let me do that, but I'd have to switch from calling them all in turn inside a scenario block to calling them inside context blocks and passing blocks to each of the `Given`, `When`, etc methods. I think it would be something like (warning, untested)

```ruby
Rspec.feature "Admin: Posts" do
  Given { @user = create :user, :admin }
  Given { login_as @user }

  context "authoring a post" do
    When { visit new_admin_post_path }
    When { fill_in :… }
    Then { visit root_url }
    And { expect(page).to have_content("RSpec feature specs") }
  end
end
```

Now this didn't _quite_ fit with what I wanted. However, I did wonder if it was possible to go down the route of having a `Given` method that takes a token to identify the code it should call. (A method if you will.) It's possible in ruby to call a method starting with a Capital letter, but convention dictates those are usually class/module names (constants) rather than methods.

A little bit of hacking later and this is what I ended up getting working:

```ruby
RSpec.feature "Admin: Posts" do
  scenario "Authoring a post" do
    Given :"I am logged in as an admin"
    When :"I publish a new post"
    Then :"I see the post on the homepage"
  end

  protected

  def_Given :"I am logged in as an admin" do
    @user = create :user, :admin
    login_as @user
  end

  def_When :"I publish a new post" do
    visit new_admin_post_path

    fill_in "Title", with: "RSpec feature specs"
    fill_in "Body", with: "Some piffle about feature specs"
    click_on "Publish!"
  end

  def_Then :"I see the post on the homepage" do
    visit root_url
    expect(page).to have_content("RSpec feature specs")
  end
end
```

Now there's two extra things that makes this easier for me to write than underscored methods. Ruby doesn't only allow `:foo` as a symbol, it also allows `:"foo bar"` for writing a symbol. You can then define a method based on that even though it has spaces in the method name.

My text editor[^2] also autocompletes ruby symbols from partial matches, which makes it easy to write out what I want in the scenario, run the spec and find out what methods need defining, then define the methods using autocomplete to save copy/pasting everything.

By using actual methods for these, we get a couple of other happy accidents along the way. Most ruby installs now include [did_you_mean][] out the box, which suggests methods like the one you called if your method results in a `NoMethodError`. This works quite nicely, you end up with something like

```
undefined method `When I pblish a new post' for #<RSpec::ExampleGroups::AdminPosts:0x00007faf1f9fc4c0>

    Did you mean? When I publish a new post
```

And then if you just run it without implementing any of the helper methods at all, you get a nice `NoMethodError` telling you exactly what you need to implement:

```
NoMethodError:
  undefined method `Given I am logged in as an admin' for #<RSpec::ExampleGroups::AdminPosts:0x00007fbd06598498>
```

The magic behind that makes all this work is in [`spec/support/given_when_then.rb`][gwt.rb], which is not terrible, but also probably not a great idea. 🙃

[rspec feature specs]: https://relishapp.com/rspec/rspec-rails/docs/feature-specs/feature-spec
[futurelearn]: https://www.futurelearn.com/info/blog/how-we-write-readable-feature-tests-with-rspec
[madetech]: https://www.madetech.com/blog/feature-testing-with-rspec
[Jim Weirich]: https://weirichinstitute.com/about
[rspec-given]: https://github.com/rspec-given/rspec-given
[gwt.rb]: https://gist.github.com/caius/606b80252b176e353fe0893f8888dbbf
[did_you_mean]: https://github.com/ruby/did_you_mean

[^1]: 😿
[^2]: [TextMate 2](https://macromates.com)
