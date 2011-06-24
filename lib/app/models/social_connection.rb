class SocialConnection < ActiveRecord::Base

  belongs_to :source, :polymorphic => true
  belongs_to :target, :polymorphic => true

end
