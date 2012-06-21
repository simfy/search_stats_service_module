class LogSubscriptionCancelledByUserImpl
  def self.execute(subscription_id, user_id, comment)
    ActionLog.log(subscription_id, 'Subscription', Actions::CancelledByUser, :comment => comment, :user_id => user_id)
  end
end