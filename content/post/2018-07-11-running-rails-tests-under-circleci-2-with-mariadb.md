---
title: "Running rails tests under CircleCI 2.0 with MariaDB"
date: 2018-07-11T19:30:00Z
author: Caius Durling
tag:
  - circleci
  - rails
  - ruby
  - testing
  - YAML
---

[CircleCI][] have released their version 2.0 platform, which is based on top of docker and moves the configuration for each project into a config file in the git repository.

They have a bunch of documentation at <https://circleci.com/docs/2.0/>. Basic gist is the config file lives at `.circleci/config.yml` and defines which images to run a series of commands in. You can either specify jobs to run in series, or a workflow containing jobs which can depend on each other and/or run in parallel.

The first step is finding a base image that contains ruby, node and chrome/chromedriver so the the app runs, assets compile and rails feature specs work respectively.

```yaml
version: 2
working_directory: "~/project"
docker:
  - image: "circleci/ruby:2.4.1-node-browsers"
    environment:
      RAILS_ENV: "test"
  - image: "mariadb:10.2.12"
    environment:
      MYSQL_DATABASE: "app_test"
      MYSQL_USER: "root"
      MYSQL_ALLOW_EMPTY_PASSWORD: true
      MYSQL_HOST: "localhost"
```

Once we have that then we can start on setting up our rails environment to the point we can run tests. First of all we need to install all our ruby dependencies via [bundler][].

```yaml
jobs: 
  - run:
      name: "Install ruby dependencies"
      command: "bundle install --path vendor/bundle"
```

Then we need to install our JS dependencies via [yarn][], in much the same way as we did for the ruby dependencies.

```yaml
  - run:
      name: "Install js dependencies"
      command: "yarn install"
```

Then we need to sort out our database. There's a chance that the docker instance for MariaDB hasn't come up yet, so we can lean on a tool called `dockerize` to wait for it to be available. Then we can ask rails to go ahead and setup our test database.

```yaml
  - run:
      name: "Wait for database to be available"
      command: "dockerize -wait tcp://127.0.0.1:3306 -timeout 1m"
  - run:
      name: "Setup database"
      command: "bundle exec rake db:setup"
```

And then finally we can run our tests as the final step.

```yaml
  - run:
      name: "Run tests"
      command: "bundle exec rspec"
```

Putting it all together, we have the following in `.circleci/config.yml`:

```yaml
version: 2
working_directory: "~/project"
docker:
  - image: "circleci/ruby:2.4.1-node-browsers"
    environment:
      RAILS_ENV: "test"
  - image: "mariadb:10.2.12"
    environment:
      MYSQL_DATABASE: "app_test"
      MYSQL_USER: "root"
      MYSQL_ALLOW_EMPTY_PASSWORD: true
      MYSQL_HOST: "localhost"
jobs: 
  - run:
      name: "Install ruby dependencies"
      command: "bundle install --path vendor/bundle"
  - run:
      name: "Install js dependencies"
      command: "yarn install"
  - run:
      name: "Wait for database to be available"
      command: "dockerize -wait tcp://127.0.0.1:3306 -timeout 1m"
  - run:
      name: "Setup database"
      command: "bundle exec rake db:setup"
  - run:
      name: "Run tests"
      command: "bundle exec rspec"
```

[CircleCI]: https://circleci.com
[bundler]: https://bundler.io
[yarn]: https://yarnpkg.com/lang/en/
