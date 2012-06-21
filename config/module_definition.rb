Hoth::Modules.define do
 
  service_module :action_log_service do
    env :development, :test do
      endpoint :default do
        host 'localhost'
        port 3001
        transport :http
      end
    end
 
    add_service :log_subscription_cancelled_by_user
  end
 
end