require 'misty'

module Misty
  
  SERVICES = []
  SERVICES << Service.new(:resources,:limes,["v1"])
  
  class Cloud

    Options = Struct.new(:resources)

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
