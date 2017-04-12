module Misty::Openstack::LimesV1
  def v1
    {
      # https://github.com/sapcc/limes/blob/master/docs/design/002-public-api.md
      # Note: the query string is the last parameter and automatically added if existing
      # without query string
      # cloud.resources.get_domain(ENV["TEST_DOMAIN_ID"])
      # with query string
      # cloud.resources.get_domain(ENV["TEST_DOMAIN_ID"], "resource=cores&service=compute&resource=ram")
      
      "/v1/clusters" => {:GET=>[:get_clusters]},
      "/v1/clusters/{cluster_id}" => {:GET=>[:get_cluster]},
      "/v1/domains" => {:GET=>[:get_domains]},
      "/v1/domains/{domain_id}" => {:GET=>[:get_domain], :PUT=>[:set_quota_for_domain]},
      "/v1/domains/{domain_id}/projects/{project_id}" => {:GET=>[:get_project], :PUT=>[:set_quota_for_domain_project]},
      
      "/v1/domains/discover" => {:POST=>[:discover_domains]},
      "/v1/domains/{domain_id}/projects/discover" => {:POST=>[:discover_domain_projects]},
      "/v1/domains/{domain_id}/projects/{project_id}/sync" => {:POST=>[:sync_project]},
    }
  end
end
