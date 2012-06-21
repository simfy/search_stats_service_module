class ActionLog < ActiveRecord::Base
  
  attr_accessible :action_object_id, :action_object_type, :comment, :user_id, :action
  # belongs_to :action_object, :polymorphic => true
  # belongs_to :user
  has_enum :action
  
  scope :for_action, lambda { |action| { :conditions => { :action => action.name } } }
  scope :for_object, lambda { |object| { :conditions => { :action_object_type => object.class.base_class.name, :action_object_id => object.id } } }
  scope :since, lambda { |date| { :conditions => ["created_at > ?", date] } }
  
  class <<self
    # for example: ActionLog.log(subscription, Actions::ManualFix, :comment => "hab bla gemacht")
    def log(action_object_id, action_object_type, action, options = {})
      user_id = options[:user_id] || options[:actor_id]
      comment = options[:comment]
      create!(:action_object_id => action_object_id, :action_object_type => action_object_type, :comment => comment, :user_id => user_id, :action => action)
    end
    
    def for_object_and_action(object, action, options = {})
      logs = for_object(object).for_action(action)
      logs.since(options[:since]) if options[:since]
      logs
    end
  end
  
end