module Misty::Openstack::LimesV1
  def v1
# Also sowas wie `limes.get_project_data(domain_id, project_id, "service=compute&resource=ram")`.
# Bleibt die Frage, wie man so einen Query-String kompiliert. Da gibt es sicher ne fertige Methode für.
#
# Hm, das hier sollte gehen: `query_str = Excon::Utils.query_string(query: { service: "compute", resource: "ram" })`. Nicht schön, aber selten. :)
# Das versteht dann auch Mehrfachargumente: `Excon::Utils.query_string(query: { service: ["object-store","volumev2"] }) == "service=object-store&service=volumev2`
    {
      "/v1/clusters" => {:GET=>[:get_clusters]},
      #"/v1/clusters{query}" => {:GET=>[:get_clusters]},

      "/v1/clusters/{cluster_id}" => {:GET=>[:get_cluster]},
      #"/v1/clusters/{cluster_id}{query}" => {:GET=>[:get_cluster]},
      
      "/v1/domains" => {:GET=>[:get_domains]},
      #"/v1/domains{query}" => {:GET=>[:get_domains]},
      
      "/v1/domains/{domain_id}" => {:GET=>[:get_domain], :PUT=>[:set_quota_for_domain]},
      #"/v1/domains/{domain_id}{query}" => {:GET=>[:get_domain]},
      
      "/v1/domains/{domain_id}/projects/{project_id}" => {:GET=>[:get_project], :PUT=>[:set_quota_for_domain_project]},
      #"/v1/domains/{domain_id}/projects/{project_id}{query}" => {:GET=>[:get_project]},
      
      "/v1/domains/discover" => {:POST=>[:discover_domains]},
      "/v1/domains/{domain_id}/projects/discover" => {:POST=>[:discover_domain_projects]},
      "/v1/domains/{domain_id}/projects/{project_id}/sync" => {:POST=>[:sync_project]},
    }
  end
end
