require 'misty'

module Misty

  @services_plus_limes = self.services
  @services_plus_limes.add(:resources, :limes, ["v1"])

  def self.services
    @services_plus_limes
  end

  class Cloud
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
