module Misty::Openstack::LimesV1
  def v1
    {
      "/v1/clusters" => {:GET=>[:get_clusters]},
      "/v1/clusters?service={service}" => {:GET=>[:get_service_for_clusters]},
      "/v1/clusters?service={service}&resource={resource}" => {:GET=>[:get_service_resource_for_clusters]},

      "/v1/clusters/{cluster_id}" => {:GET=>[:get_cluster]},
      "/v1/clusters/{cluster_id}?service={service}" => {:GET=>[:get_service_for_cluster]},
      "/v1/clusters/{cluster_id}?service={service}&resource={resource}" => {:GET=>[:get_service_resource_for_cluster]},
      
      "/v1/domains" => {:GET=>[:get_domains]},
      "/v1/domains?service={service}" => {:GET=>[:get_service_for_domains]},
      "/v1/domains?service={service}&resource={resource}" => {:GET=>[:get_service_resource_for_domains]},
      
      "/v1/domains/{domain_id}" => {:GET=>[:get_domain], :PUT=>[:set_quota_for_domain]},
      "/v1/domains/{domain_id}?service={service}" => {:GET=>[:get_service_for_domain]},
      "/v1/domains/{domain_id}?service={service}&resource={resource}" => {:GET=>[:get_service_resource_for_domain]},
      
      "/v1/domains/{domain_id}/projects/{project_id}" => {:GET=>[:get_project], :PUT=>[:set_quota_for_domain_project]},
      "/v1/domains/{domain_id}/projects/{project_id}?service={service}" => {:GET=>[:get_service_for_project]},
      "/v1/domains/{domain_id}/projects/{project_id}?service={service}&resource={resource}" => {:GET=>[:get_service_resource_for_project]},
      
      "/v1/domains/discover" => {:POST=>[:discover_domains]},
      "/v1/domains/{domain_id}/projects/discover" => {:POST=>[:discover_domain_projects]},
      "/v1/domains/{domain_id}/projects/{project_id}/sync" => {:POST=>[:sync_project]},
    }
  end
end
