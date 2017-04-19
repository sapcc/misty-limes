require 'misty'

module Misty
  
  class Cloud

    def initialize(params = {:auth => {}})
      @params = params
      @config = self.class.set_configuration(params)
      @services = Misty.services
      @services.add(:resources,:limes,["v1"])
    end

    def resources
      @resources ||= build_service(:resources)
    end

  end

  module Openstack
    module Limes
      autoload :V1, "misty/openstack/limes/v1"
    end
  end
end
