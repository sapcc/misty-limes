require 'misty/http/client'
require "misty/openstack/limes/limes_v1"

module Misty
  module Openstack
    module Limes
      class V1 < Misty::HTTP::Client
        extend Misty::Openstack::LimesV1

        def self.api
          v1
        end

        def self.service_names
          %w{resources}
        end
      end
    end
  end
end
