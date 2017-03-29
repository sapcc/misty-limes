require 'test_helper'
require 'misty/openstack/limes'

# http://docs.seattlerb.org/minitest/
# https://github.com/sapcc/limes/blob/master/docs/design/002-public-api.md

describe "limes features" do
  it "GET requests project resources" do
    VCR.use_cassette "requesting project resources using api V1" do
      
      cloud = Misty::Cloud.new(:auth => auth_project, :region_id => "staging", :log_level => 2, :ssl_verify_mode => false)
      
      services = cloud.services
      services[:resources][:limes].must_equal "v1"
      
      response = cloud.resources.get_project("d247861f96094b689d1b358513638296","2b121dc9245c4a4bae5ffa494b586be8")
      response.code.must_equal "200"
      assert_equal "2b121dc9245c4a4bae5ffa494b586be8", response.body["project"]["id"], "check for project id"
      assert_equal "object-store", response.body["project"]["services"][1]["type"], "check for service  object-store"
      assert_equal "capacity", response.body["project"]["services"][1]["resources"][0]["name"], "check for resource capacity"
      assert_equal "B", response.body["project"]["services"][1]["resources"][0]["unit"], "check resource unit"
      assert_kind_of Integer, response.body["project"]["services"][1]["resources"][0]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["project"]["services"][1]["resources"][0]["usage"], "check resource usage"
      
      response = cloud.resources.get_service_for_project("d247861f96094b689d1b358513638296","2b121dc9245c4a4bae5ffa494b586be8","compute")
      response.code.must_equal "200"
      assert_equal "2b121dc9245c4a4bae5ffa494b586be8", response.body["project"]["id"], "check for project id"
      assert_equal "compute", response.body["project"]["services"][0]["type"], "check for service  compute"
      assert_equal "instances", response.body["project"]["services"][0]["resources"][1]["name"], "check for resource instances"
      assert_kind_of Integer, response.body["project"]["services"][0]["resources"][1]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["project"]["services"][0]["resources"][1]["usage"], "check resource usage"

      response = cloud.resources.get_service_resource_for_project("d247861f96094b689d1b358513638296","2b121dc9245c4a4bae5ffa494b586be8","compute","cores")
      response.code.must_equal "200"
      assert_equal "2b121dc9245c4a4bae5ffa494b586be8", response.body["project"]["id"], "check for project id"
      assert_equal "compute", response.body["project"]["services"][0]["type"], "check for service  compute"
      assert_equal "cores", response.body["project"]["services"][0]["resources"][0]["name"], "check for resource cores"
      assert_kind_of Integer, response.body["project"]["services"][0]["resources"][0]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["project"]["services"][0]["resources"][0]["usage"], "check resource usage"

      response = cloud.resources.sync_project("d247861f96094b689d1b358513638296","2b121dc9245c4a4bae5ffa494b586be8")
      response.code.must_equal "202"

    end
  end
  
  it "GET requests domain resources" do
    VCR.use_cassette "requesting domain resources using api V1" do
      
      cloud = Misty::Cloud.new(:auth => auth_domain, :region_id => "staging", :log_level => 2, :ssl_verify_mode => false)
      
      services = cloud.services
      services[:resources][:limes].must_equal "v1"
      
      response = cloud.resources.get_domain("d247861f96094b689d1b358513638296")
      response.code.must_equal "200"
      assert_equal "d247861f96094b689d1b358513638296", response.body["domain"]["id"], "check for domain id"
      assert_equal "object-store", response.body["domain"]["services"][1]["type"], "check for service  object-store"
      assert_equal "capacity", response.body["domain"]["services"][1]["resources"][0]["name"], "check for resource capacity"
      assert_equal "B", response.body["domain"]["services"][1]["resources"][0]["unit"], "check resource unit"
      assert_kind_of Integer, response.body["domain"]["services"][1]["resources"][0]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["domain"]["services"][1]["resources"][0]["usage"], "check resource usage"

      response = cloud.resources.get_service_for_domain("d247861f96094b689d1b358513638296","compute")
      response.code.must_equal "200"
      assert_equal "d247861f96094b689d1b358513638296", response.body["domain"]["id"], "check for domain id"
      assert_equal "compute", response.body["domain"]["services"][0]["type"], "check for service  compute"
      assert_equal "instances", response.body["domain"]["services"][0]["resources"][1]["name"], "check for resource instances"
      assert_kind_of Integer, response.body["domain"]["services"][0]["resources"][1]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["domain"]["services"][0]["resources"][1]["usage"], "check resource usage"
      
      response = cloud.resources.get_service_resource_for_domain("d247861f96094b689d1b358513638296","compute","cores")
      response.code.must_equal "200"
      assert_equal "d247861f96094b689d1b358513638296", response.body["domain"]["id"], "check for domain id"
      assert_equal "compute", response.body["domain"]["services"][0]["type"], "check for service  compute"
      assert_equal "cores", response.body["domain"]["services"][0]["resources"][0]["name"], "check for resource cores"
      assert_kind_of Integer, response.body["domain"]["services"][0]["resources"][0]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["domain"]["services"][0]["resources"][0]["usage"], "check resource usage"

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

      response = cloud.resources.set_quota_for_domain("d247861f96094b689d1b358513638296", "domain" => new_quota)
      #TODO -> TEST
      
      response = cloud.resources.discover_domains_projects("d247861f96094b689d1b358513638296")
      response.code.must_equal "204"

    end
  end

  it "GET requests domains resources" do
    VCR.use_cassette "requesting domains resources using api V1" do
      
      cloud = Misty::Cloud.new(:auth => auth_cloud_admin, :region_id => "staging", :log_level => 2, :ssl_verify_mode => false)
      services = cloud.services
      services[:resources][:limes].must_equal "v1"
      
      response = cloud.resources.get_domains
      response.code.must_equal "200"
      assert_equal "object-store", response.body["domains"][0]["services"][1]["type"], "check for service  object-store"
      assert_equal "capacity", response.body["domains"][0]["services"][1]["resources"][0]["name"], "check for resource capacity"
      assert_equal "B", response.body["domains"][0]["services"][1]["resources"][0]["unit"], "check resource unit"
      assert_kind_of Integer, response.body["domains"][0]["services"][1]["resources"][0]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["domains"][0]["services"][1]["resources"][0]["usage"], "check resource usage"
      
      response = cloud.resources.get_service_for_domains("compute")
      response.code.must_equal "200"
      assert_equal "compute", response.body["domains"][0]["services"][0]["type"], "check for service  compute"
      assert_equal "instances", response.body["domains"][0]["services"][0]["resources"][1]["name"], "check for resource instances"
      assert_kind_of Integer, response.body["domains"][0]["services"][0]["resources"][1]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["domains"][0]["services"][0]["resources"][1]["usage"], "check resource usage"

      response = cloud.resources.get_service_resource_for_domains("compute","cores")
      response.code.must_equal "200"
      assert_equal "compute", response.body["domains"][0]["services"][0]["type"], "check for service  compute"
      assert_equal "cores", response.body["domains"][0]["services"][0]["resources"][0]["name"], "check for resource cores"
      assert_kind_of Integer, response.body["domains"][0]["services"][0]["resources"][0]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["domains"][0]["services"][0]["resources"][0]["usage"], "check resource usage"
      
      response = cloud.resources.discover_domains
      response.code.must_equal "204"
      
    end
  end

  it "GET requests cluster resources" do
    VCR.use_cassette "requesting cluster resources using api V1" do
      
      cloud = Misty::Cloud.new(:auth => auth_cloud_admin, :region_id => "staging", :log_level => 2, :ssl_verify_mode => false)
      services = cloud.services
      services[:resources][:limes].must_equal "v1"
      
      response = cloud.resources.get_cluster("ccloud")
      response.code.must_equal "200"
      assert_equal "ccloud", response.body["cluster"]["id"], "check for cluster id"
      assert_equal "object-store", response.body["cluster"]["services"][1]["type"], "check for service  object-store"
      assert_equal "capacity", response.body["cluster"]["services"][1]["resources"][0]["name"], "check for resource capacity"
      assert_equal "B", response.body["cluster"]["services"][1]["resources"][0]["unit"], "check resource unit"
      assert_kind_of Integer, response.body["cluster"]["services"][1]["resources"][0]["domains_quota"], "check resource quota"
      assert_kind_of Integer, response.body["cluster"]["services"][1]["resources"][0]["usage"], "check resource usage"

      response = cloud.resources.get_service_for_cluster("ccloud","compute")
      response.code.must_equal "200"
      assert_equal "ccloud", response.body["cluster"]["id"], "check for cluster id"
      assert_equal "compute", response.body["cluster"]["services"][0]["type"], "check for service  compute"
      assert_equal "instances", response.body["cluster"]["services"][0]["resources"][1]["name"], "check for resource instances"
      assert_kind_of Integer, response.body["cluster"]["services"][0]["resources"][1]["domains_quota"], "check resource quota"
      assert_kind_of Integer, response.body["cluster"]["services"][0]["resources"][1]["usage"], "check resource usage"
      
      response = cloud.resources.get_service_resource_for_cluster("ccloud","compute","cores")
      response.code.must_equal "200"
      assert_equal "ccloud", response.body["cluster"]["id"], "check for cluster id"
      assert_equal "compute", response.body["cluster"]["services"][0]["type"], "check for service  compute"
      assert_equal "cores", response.body["cluster"]["services"][0]["resources"][0]["name"], "check for resource cores"
      assert_kind_of Integer, response.body["cluster"]["services"][0]["resources"][0]["domains_quota"], "check resource quota"
      assert_kind_of Integer, response.body["cluster"]["services"][0]["resources"][0]["usage"], "check resource usage"

    end
  end

  it "GET requests clusters resources" do
    VCR.use_cassette "requesting clusters resources using api V1" do
      
      cloud = Misty::Cloud.new(:auth => auth_cloud_admin, :region_id => "staging", :log_level => 2, :ssl_verify_mode => false)
      services = cloud.services
      services[:resources][:limes].must_equal "v1"
      
      response = cloud.resources.get_clusters
      response.code.must_equal "200"
      assert_equal "object-store", response.body["clusters"][0]["services"][1]["type"], "check for service  object-store"
      assert_equal "capacity", response.body["clusters"][0]["services"][1]["resources"][0]["name"], "check for resource capacity"
      assert_equal "B", response.body["clusters"][0]["services"][1]["resources"][0]["unit"], "check resource unit"
      assert_kind_of Integer, response.body["clusters"][0]["services"][1]["resources"][0]["domains_quota"], "check resource quota"
      assert_kind_of Integer, response.body["clusters"][0]["services"][1]["resources"][0]["usage"], "check resource usage"

      response = cloud.resources.get_service_for_clusters("compute")
      response.code.must_equal "200"
      assert_equal "compute", response.body["clusters"][0]["services"][0]["type"], "check for service  compute"
      assert_equal "instances", response.body["clusters"][0]["services"][0]["resources"][1]["name"], "check for resource instances"
      assert_kind_of Integer, response.body["clusters"][0]["services"][0]["resources"][1]["domains_quota"], "check resource quota"
      assert_kind_of Integer, response.body["clusters"][0]["services"][0]["resources"][1]["usage"], "check resource usage"

      response = cloud.resources.get_service_resource_for_clusters("compute","cores")
      response.code.must_equal "200"
      assert_equal "compute", response.body["clusters"][0]["services"][0]["type"], "check for service  compute"
      assert_equal "cores", response.body["clusters"][0]["services"][0]["resources"][0]["name"], "check for resource cores"
      assert_kind_of Integer, response.body["clusters"][0]["services"][0]["resources"][0]["domains_quota"], "check resource quota"
      assert_kind_of Integer, response.body["clusters"][0]["services"][0]["resources"][0]["usage"], "check resource usage"
      
    end
  end

end