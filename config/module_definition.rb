Hoth::Modules.define do
 
  service_module :search_stats_service_module do
    env :development, :test do
      endpoint :default do
        host 'localhost'
        port 3001
        transport :http
      end
    end
    env :staging do
      endpoint :default do
        host 'localhost'
        port 9002
        transport :http
      end
    end
 
    add_service :increment_search_term_score
    add_service :get_search_term_score
    add_service :get_top_search_terms
    add_service :reset_all_search_stats
  end
 
end