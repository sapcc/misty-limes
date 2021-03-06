require 'test_helper'
require 'misty/openstack/limes'

# http://docs.seattlerb.org/minitest/
# https://github.com/sapcc/limes/blob/master/docs/design/002-public-api.md

describe "limes features" do

  it "GET requests project resources" do
    VCR.use_cassette "requesting project resources using api V1" do
      
      cloud = Misty::Cloud.new(
        :auth             => auth_project,
        :region_id        => ENV["TEST_REGION_ID"],
        :log_level        => 2,
        :ssl_verify_mode  => false,
        :http_proxy       => ENV['http_proxy']
      )
      
      response = cloud.resources.get_project(ENV["TEST_DOMAIN_ID"],ENV["TEST_PROJECT_ID"])
      response.code.must_equal "200"
      assert_equal ENV["TEST_PROJECT_ID"], response.body["project"]["id"], "check for project id"
      assert_equal "object-store", response.body["project"]["services"][2]["type"], "check for service  object-store"
      assert_equal "capacity", response.body["project"]["services"][2]["resources"][0]["name"], "check for resource capacity"
      assert_equal "B", response.body["project"]["services"][2]["resources"][0]["unit"], "check resource unit"
      assert_kind_of Integer, response.body["project"]["services"][2]["resources"][0]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["project"]["services"][2]["resources"][0]["usage"], "check resource usage"
      
      response = cloud.resources.get_project(ENV["TEST_DOMAIN_ID"],ENV["TEST_PROJECT_ID"],"resource=cores&service=compute&resource=ram")
      response.code.must_equal "200"
      assert_equal "compute", response.body["project"]["services"][0]["type"], "check for service  compute"
      assert_equal "cores", response.body["project"]["services"][0]["resources"][0]["name"], "check for resource cores"
      assert_kind_of Integer, response.body["project"]["services"][0]["resources"][0]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["project"]["services"][0]["resources"][0]["usage"], "check resource usage"
      assert_equal "ram", response.body["project"]["services"][0]["resources"][1]["name"], "check for resource ram"
      assert_kind_of Integer, response.body["project"]["services"][0]["resources"][1]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["project"]["services"][0]["resources"][1]["usage"], "check resource usage"

      response = cloud.resources.sync_project(ENV["TEST_DOMAIN_ID"],ENV["TEST_PROJECT_ID"])
      response.code.must_equal "202"

    end
  end

  it "GET requests project resources" do
    VCR.use_cassette "requesting projects resources using api V1" do
      
      cloud = Misty::Cloud.new(
        :auth             => auth_domain, 
        :region_id        => ENV["TEST_REGION_ID"], 
        :log_level        => 2, 
        :ssl_verify_mode  => false,
        :http_proxy       => ENV['http_proxy']
      )
      
      response = cloud.resources.get_projects(ENV["TEST_DOMAIN_ID"])
      response.code.must_equal "200"
      assert_equal "object-store", response.body["projects"][0]["services"][2]["type"], "check for service  object-store"
      assert_equal "capacity", response.body["projects"][0]["services"][2]["resources"][0]["name"], "check for resource capacity"
      assert_equal "B", response.body["projects"][0]["services"][2]["resources"][0]["unit"], "check resource unit"
      assert_kind_of Integer, response.body["projects"][0]["services"][2]["resources"][0]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["projects"][0]["services"][2]["resources"][0]["usage"], "check resource usage"
      
      response = cloud.resources.get_projects(ENV["TEST_DOMAIN_ID"],"resource=cores&service=compute&resource=ram")
      response.code.must_equal "200"
      assert_equal "compute", response.body["projects"][0]["services"][0]["type"], "check for service  compute"
      assert_equal "cores", response.body["projects"][0]["services"][0]["resources"][0]["name"], "check for resource cores"
      assert_kind_of Integer, response.body["projects"][0]["services"][0]["resources"][0]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["projects"][0]["services"][0]["resources"][0]["usage"], "check resource usage"
      assert_equal "ram", response.body["projects"][0]["services"][0]["resources"][1]["name"], "check for resource ram"
      assert_kind_of Integer, response.body["projects"][0]["services"][0]["resources"][1]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["projects"][0]["services"][0]["resources"][1]["usage"], "check resource usage"

    end
  end
  
  it "GET requests domain resources" do
    VCR.use_cassette "requesting domain resources using api V1" do
      
      cloud = Misty::Cloud.new(
        :auth => auth_domain,
        :region_id        => ENV["TEST_REGION_ID"],
        :log_level        => 2,
        :ssl_verify_mode  => false,
        :http_proxy       => ENV['http_proxy']
      )
      
      response = cloud.resources.get_domain(ENV["TEST_DOMAIN_ID"])
      response.code.must_equal "200"
      assert_equal ENV["TEST_DOMAIN_ID"], response.body["domain"]["id"], "check for domain id"
      assert_equal "object-store", response.body["domain"]["services"][2]["type"], "check for service  object-store"
      assert_equal "capacity", response.body["domain"]["services"][2]["resources"][0]["name"], "check for resource capacity"
      assert_equal "B", response.body["domain"]["services"][2]["resources"][0]["unit"], "check resource unit"
      assert_kind_of Integer, response.body["domain"]["services"][2]["resources"][0]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["domain"]["services"][2]["resources"][0]["usage"], "check resource usage"

      response = cloud.resources.get_domain(ENV["TEST_DOMAIN_ID"],"resource=cores&service=compute&resource=ram")
      response.code.must_equal "200"
      assert_equal "compute", response.body["domain"]["services"][0]["type"], "check for service  compute"
      assert_equal "cores", response.body["domain"]["services"][0]["resources"][0]["name"], "check for resource cores"
      assert_kind_of Integer, response.body["domain"]["services"][0]["resources"][0]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["domain"]["services"][0]["resources"][0]["usage"], "check resource usage"
      assert_equal "ram", response.body["domain"]["services"][0]["resources"][1]["name"], "check for resource ram"
      assert_kind_of Integer, response.body["domain"]["services"][0]["resources"][1]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["domain"]["services"][0]["resources"][1]["usage"], "check resource usage"

      new_quota = { 
                    "project" => {
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
                  }

      response = cloud.resources.set_quota_for_project(ENV["TEST_DOMAIN_ID"],ENV["TEST_PROJECT_ID"],new_quota)
      response.code.must_equal "200"
      response = cloud.resources.get_project(ENV["TEST_DOMAIN_ID"],ENV["TEST_PROJECT_ID"],"resource=cores&service=compute&resource=instances")
      assert_equal "compute", response.body["project"]["services"][0]["type"], "check for service  compute"
      assert_equal "cores", response.body["project"]["services"][0]["resources"][0]["name"], "check for resource cores"
      assert_equal 10, response.body["project"]["services"][0]["resources"][0]["quota"], "check quota set value for cores"
      assert_equal "instances", response.body["project"]["services"][0]["resources"][1]["name"], "check for resource instances"
      assert_equal 10, response.body["project"]["services"][0]["resources"][1]["quota"], "check quota set value for instances"

      response = cloud.resources.discover_projects(ENV["TEST_DOMAIN_ID"])
      response.code.must_equal "204"

    end
  end

  it "GET requests domains resources" do
    VCR.use_cassette "requesting domains resources using api V1" do
      
      cloud = Misty::Cloud.new(
        :auth             => auth_cloud_admin,
        :region_id        => ENV["TEST_REGION_ID"],
        :log_level        => 2,
        :ssl_verify_mode  => false,
        :http_proxy       => ENV['http_proxy']
      )
      
      response = cloud.resources.get_domains
      response.code.must_equal "200"
      assert_equal "object-store", response.body["domains"][0]["services"][2]["type"], "check for service  object-store"
      assert_equal "capacity", response.body["domains"][0]["services"][2]["resources"][0]["name"], "check for resource capacity"
      assert_equal "B", response.body["domains"][0]["services"][2]["resources"][0]["unit"], "check resource unit"
      assert_kind_of Integer, response.body["domains"][0]["services"][2]["resources"][0]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["domains"][0]["services"][2]["resources"][0]["usage"], "check resource usage"
      
      response = cloud.resources.get_domains("resource=cores&service=compute&resource=ram")
      response.code.must_equal "200"
      assert_equal "compute", response.body["domains"][0]["services"][0]["type"], "check for service  compute"
      assert_equal "cores", response.body["domains"][0]["services"][0]["resources"][0]["name"], "check for resource cores"
      assert_kind_of Integer, response.body["domains"][0]["services"][0]["resources"][0]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["domains"][0]["services"][0]["resources"][0]["usage"], "check resource usage"
      assert_equal "ram", response.body["domains"][0]["services"][0]["resources"][1]["name"], "check for resource ram"
      assert_kind_of Integer, response.body["domains"][0]["services"][0]["resources"][1]["quota"], "check resource quota"
      assert_kind_of Integer, response.body["domains"][0]["services"][0]["resources"][1]["usage"], "check resource usage"

      response = cloud.resources.discover_domains
      response.code.must_equal "204"
      
    end
  end

  it "GET requests cluster resources" do
    VCR.use_cassette "requesting cluster resources using api V1" do
      
      cloud = Misty::Cloud.new(
        :auth             => auth_cloud_admin,
        :region_id        => ENV["TEST_REGION_ID"],
        :log_level        => 2,
        :ssl_verify_mode  => false,
        :http_proxy       => ENV['http_proxy']
      )
      
      response = cloud.resources.get_cluster("ccloud")
      response.code.must_equal "200"
      assert_equal "ccloud", response.body["cluster"]["id"], "check for cluster id"
      assert_equal "object-store", response.body["cluster"]["services"][2]["type"], "check for service  object-store"
      assert_equal "capacity", response.body["cluster"]["services"][2]["resources"][0]["name"], "check for resource capacity"
      assert_equal "B", response.body["cluster"]["services"][2]["resources"][0]["unit"], "check resource unit"
      assert_kind_of Integer, response.body["cluster"]["services"][2]["resources"][0]["domains_quota"], "check resource quota"
      assert_kind_of Integer, response.body["cluster"]["services"][2]["resources"][0]["usage"], "check resource usage"
      
      response = cloud.resources.get_cluster("ccloud","resource=cores&service=compute&resource=ram")
      response.code.must_equal "200"
      assert_equal "compute", response.body["cluster"]["services"][0]["type"], "check for service  compute"
      assert_equal "cores", response.body["cluster"]["services"][0]["resources"][0]["name"], "check for resource cores"
      assert_kind_of Integer, response.body["cluster"]["services"][0]["resources"][0]["domains_quota"], "check resource quota"
      assert_kind_of Integer, response.body["cluster"]["services"][0]["resources"][0]["usage"], "check resource usage"
      assert_equal "ram", response.body["cluster"]["services"][0]["resources"][1]["name"], "check for resource ram"
      assert_kind_of Integer, response.body["cluster"]["services"][0]["resources"][1]["domains_quota"], "check resource quota"
      assert_kind_of Integer, response.body["cluster"]["services"][0]["resources"][1]["usage"], "check resource usage"

      response.body 

      new_capacity_1 =  { "cluster": {
                            "services": [
                              {
                                "type": "compute",
                                "resources": [
                                  {
                                    "name": "instances",
                                    "capacity": 200,
                                    "comment": "guesstimate"
                                  },
                                  {
                                    "name": "cores",
                                    "capacity": 400,
                                    "comment": "counted them by hand"
                                  }
                                ]
                              }
                            ]
                          }
                        }
      
      response = cloud.resources.set_capacity_for_current_cluster(new_capacity_1)
      response.code.must_equal "200"

      response = cloud.resources.get_cluster("ccloud","resource=cores&service=compute&resource=instances")
      response.code.must_equal "200"
      assert_equal "compute", response.body["cluster"]["services"][0]["type"], "check for service  compute"
      assert_equal "cores", response.body["cluster"]["services"][0]["resources"][0]["name"], "check for resource cores"
      assert_equal 400, response.body["cluster"]["services"][0]["resources"][0]["capacity"], "check resource capacity value for cores"
      assert_equal "instances", response.body["cluster"]["services"][0]["resources"][1]["name"], "check for resource ram"
      assert_equal 200, response.body["cluster"]["services"][0]["resources"][1]["capacity"], "check resource capacity value for instances"

      new_capacity_2 =  { "cluster": {
                            "services": [
                              {
                                "type": "compute",
                                "resources": [
                                  {
                                    "name": "instances",
                                    "capacity": 300,
                                    "comment": "guesstimate"
                                  },
                                  {
                                    "name": "cores",
                                    "capacity": 500,
                                    "comment": "counted them by hand"
                                  }
                                ]
                              }
                            ]
                          }
                        }

      response = cloud.resources.set_capacity_for_cluster("ccloud",new_capacity_2)
      response.code.must_equal "200"

      response = cloud.resources.get_cluster("ccloud","resource=cores&service=compute&resource=instances")
      response.code.must_equal "200"
      assert_equal "compute", response.body["cluster"]["services"][0]["type"], "check for service  compute"
      assert_equal "cores", response.body["cluster"]["services"][0]["resources"][0]["name"], "check for resource cores"
      assert_equal 500, response.body["cluster"]["services"][0]["resources"][0]["capacity"], "check resource capacity value for cores"
      assert_equal "instances", response.body["cluster"]["services"][0]["resources"][1]["name"], "check for resource ram"
      assert_equal 300, response.body["cluster"]["services"][0]["resources"][1]["capacity"], "check resource capacity value for instances"

    end
  end

  it "GET requests current cluster resources" do
    VCR.use_cassette "requesting current cluster resources using api V1" do
      
      cloud = Misty::Cloud.new(
        :auth             => auth_cloud_admin,
        :region_id        => ENV["TEST_REGION_ID"],
        :log_level        => 2,
        :ssl_verify_mode  => false,
        :http_proxy       => ENV['http_proxy']
      )
      
      response = cloud.resources.get_current_cluster
      response.code.must_equal "200"
      assert_equal "object-store", response.body["cluster"]["services"][2]["type"], "check for service  object-store"
      assert_equal "capacity", response.body["cluster"]["services"][2]["resources"][0]["name"], "check for resource capacity"
      assert_equal "B", response.body["cluster"]["services"][2]["resources"][0]["unit"], "check resource unit"
      assert_kind_of Integer, response.body["cluster"]["services"][2]["resources"][0]["domains_quota"], "check resource quota"
      assert_kind_of Integer, response.body["cluster"]["services"][2]["resources"][0]["usage"], "check resource usage"

      response = cloud.resources.get_current_cluster("resource=cores&service=compute&resource=ram")
      response.code.must_equal "200"
      assert_equal "compute", response.body["cluster"]["services"][0]["type"], "check for service  compute"
      assert_equal "cores", response.body["cluster"]["services"][0]["resources"][0]["name"], "check for resource cores"
      assert_kind_of Integer, response.body["cluster"]["services"][0]["resources"][0]["domains_quota"], "check resource quota"
      assert_kind_of Integer, response.body["cluster"]["services"][0]["resources"][0]["usage"], "check resource usage"
      assert_equal "ram", response.body["cluster"]["services"][0]["resources"][1]["name"], "check for resource ram"
      assert_kind_of Integer, response.body["cluster"]["services"][0]["resources"][1]["domains_quota"], "check resource quota"
      assert_kind_of Integer, response.body["cluster"]["services"][0]["resources"][1]["usage"], "check resource usage"

    end
  end

  it "GET requests clusters resources" do
    VCR.use_cassette "requesting clusters resources using api V1" do
      
      cloud = Misty::Cloud.new(
        :auth             => auth_cloud_admin,
        :region_id        => ENV["TEST_REGION_ID"],
        :log_level        => 2,
        :ssl_verify_mode  => false,
        :http_proxy       => ENV['http_proxy']
      )
      
      response = cloud.resources.get_clusters
      response.code.must_equal "200"
      assert_equal "object-store", response.body["clusters"][0]["services"][2]["type"], "check for service  object-store"
      assert_equal "capacity", response.body["clusters"][0]["services"][2]["resources"][0]["name"], "check for resource capacity"
      assert_equal "B", response.body["clusters"][0]["services"][2]["resources"][0]["unit"], "check resource unit"
      assert_kind_of Integer, response.body["clusters"][0]["services"][2]["resources"][0]["domains_quota"], "check resource quota"
      assert_kind_of Integer, response.body["clusters"][0]["services"][2]["resources"][0]["usage"], "check resource usage"

      response = cloud.resources.get_clusters("resource=cores&service=compute&resource=ram")
      response.code.must_equal "200"
      assert_equal "compute", response.body["clusters"][0]["services"][0]["type"], "check for service  compute"
      assert_equal "cores", response.body["clusters"][0]["services"][0]["resources"][0]["name"], "check for resource cores"
      assert_kind_of Integer, response.body["clusters"][0]["services"][0]["resources"][0]["domains_quota"], "check resource quota"
      assert_kind_of Integer, response.body["clusters"][0]["services"][0]["resources"][0]["usage"], "check resource usage"
      assert_equal "ram", response.body["clusters"][0]["services"][0]["resources"][1]["name"], "check for resource ram"
      assert_kind_of Integer, response.body["clusters"][0]["services"][0]["resources"][1]["domains_quota"], "check resource quota"
      assert_kind_of Integer, response.body["clusters"][0]["services"][0]["resources"][1]["usage"], "check resource usage"

    end
  end

end