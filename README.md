# Misty::Openstack::Limes

This is the plugin Gem to consume the OpenStack Limes API.

The main maintainer for the OpenStack limes section are **@hgw77**, **@majewsky**.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'misty-limes', git: 'https://github.com/sapcc/misty-limes'
```

And then execute:

    $ bundle

### Initial Setup

Require the gem:

```ruby
require 'misty/openstack/limes'
```

## Usage

coming soon ;-)

## Development

1. Within the directory run `rvm use ruby-2.3.1@misty-limes`
2. RUN gem install bundler
3. Run `bundle install --with=development`
4. Run the tests
    1. You need to set your env variables first, take a look to the dotenv file (TODO: use dotenv)
    1. `bundle exec rake limes`

## License

The gem is available as open source under the terms of the enclosed GPL-3.0.

