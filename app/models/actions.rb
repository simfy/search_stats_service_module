enum :Actions do
  
  ExtendSubscription()
  ResetDevices()
  PremiumAdvantagesWillExpireMailingDelivered()
  CancelledByUser()
  CancelledBySystem()
  CancelledBySupport()
  CancelledBySupportWithRefund()
  UncancelledBySupport()
  AccountDeleted()
  DismissedBeforeMigration()
  ManualFix() # if a developer has to fix something manually 
  SubscriptionUpgraded()

end