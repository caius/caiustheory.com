---
title: "Potty Training YAML"
author: "Caius Durling"
date: 2010-05-10 21:46:17 +0000
tags:
  - "geek"
  - "ruby"
  - "programming"
  - "code"
  - "fix"
  - "link"
  - "troubleshooting"
  - "YAML"
  - "potty training"
---

Ran into a problem today where I have a class with a few attributes on it, but I only want a certain three of those attributes to appear in the YAML dump of a class instance.

Diving straight into a code example--lets say we have a `Contact` class, and we only want to dump the `name`, `email` and `website` attributes.

```ruby
require "yaml"

class Contact
  attr_accessor :name, :email, :website, :telephone

  # helper method to make setting up easy
  def initialize(params={})
    params.each do |key, value|
      meffod = "#{key.to_s}="
      send(meffod, value) if respond_to?(meffod)
    end
  end
end

# And create an instance for us to play with
caius = Contact.new(
  :name => "Caius",
  :email => "dev@caius.name",
  :website => "http://caius.name/",
  :telephone => "12345"
)
```

As we'd expect when dumping this, all instance variables get dumped out:

```ruby
print caius.to_yaml
# >> --- !ruby/object:Contact 
# >> email: dev@caius.name
# >> name: Caius
# >> telephone: "12345"
# >> website: http://caius.name/
```

Initially I tried to override `to_yaml` and unset the instance variables I didn't want showing up, but that just made them show up empty. After digging around a bit more, I happened across the [Type Families][] page in the yaml4r docs, which right at the bottom mentions `to_yaml_properties`.

[Type Families]: http://yaml4r.sourceforge.net/doc/page/type_families.htm

Turns out `to_yaml_properties` returns an array of instance variable names (as strings) that should be dumped out as part of the object. A quick method definition later, and we're only dumping the variables we want. (*See my [Ruby Shortcuts][] post if you don't know what `%w()` does*)

[Ruby Shortcuts]: http://caiustheory.com/ruby-shortcuts

```ruby
class Contact
  def to_yaml_properties
    %w(@name @email @website)
  end
end
```

And now we dump the class, expecting only the three attributes to be outputted:

```ruby
print caius.to_yaml
# >> --- !ruby/object:Contact 
# >> name: Caius
# >> email: dev@caius.name
# >> website: http://caius.name/
```

Success!
