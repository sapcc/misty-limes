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

```ruby
require ''misty/openstack/limes'

auth_v3 = {
  :url              => "http://localhost:5000",
  :user             => "admin",
  :password         => "secret",
  :project_id       => "XXX",
  :domain_id        => "XXX",
  :user_domain_id   => "XXX"
}

cloud = Misty::Cloud.new(:auth => auth_v3,  :region_id => "staging", :log_level => 2)

# PROJECT SCOPE
cloud.resources.get_project("DOMAIN_ID","PROJECT_ID")
cloud.resources.get_service_for_project("DOMAIN_ID","PROJECT_ID","compute")
cloud.resources.get_service_resource_for_project("DOMAIN_ID","PROJECT_ID","compute","cores")
cloud.resources.sync_project("DOMAIN_ID","PROJECT_ID")

# DOMAIN SCOPE
cloud.resources.discover_domain_projects("DOMAIN_ID")

cloud.resources.get_domain("DOMAIN_ID")
cloud.resources.get_service_for_domain("DOMAIN_ID","compute")
cloud.resources.get_service_resource_for_domain("DOMAIN_ID","compute","cores")

new_quota = {
            "services": [
              {
                "type": "compute",
                "resources": [
                  {
                    "name": "instances",
                    "quota": 10
                  },
                  {
                    "name": "cores",
                    "quota": 10
                  }
                ]
              }
            ]
          }

cloud.resources.set_quota_for_domain("DOMAIN_ID", "domain" => new_quota)

```

## Development

1. Within the directory run `rvm use ruby-2.3.1@misty-limes`
2. RUN gem install bundler
3. Run `bundle install --with=development`
4. Run the tests
    1. You need to set your env variables first, take a look to the dotenv file (TODO: use dotenv)
    1. `bundle exec rake limes`

## License

The gem is available as open source under the terms of the enclosed Apache-2.0

