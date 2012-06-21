Hoth::Services.define do
 
  service :log_subscription_cancelled_by_user do |subscription_id, user_id, comment|
    returns :nothing
  end

end