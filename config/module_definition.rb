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
 
    add_service :set_term
    add_service :get_term
    add_service :get_top_terms
    add_service :reset_all
  end
 
end