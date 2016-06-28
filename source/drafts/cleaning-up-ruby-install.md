# Cleaning up rubies

* ruby-install to install
* chruby to use rubies
* runtime stuff in ~/.rubies
* gems install to ~/.gem

What to do when you want to reclaim some disk space?

* `ls ~/.rubies`
* `rm -rf ~/.rubies/{2.1.7,2.3.0}`

How to clean up the gems for removed ruby runtimes?

* `diff --old-line-format= --unchanged-line-format= --new-line-format=$HOME/.gem/ruby/%L <(ls ~/.rubies | sed -Ee 's/ruby-|-p[0-9]+//g') <(ls ~/.gem/ruby) | xargs rm -r`

    $ ls ~/.gem/ruby
    1.9.3 2.3.1
    $ ls ~/.rubies
    ruby-1.9.3-p551 ruby-2.3.1
