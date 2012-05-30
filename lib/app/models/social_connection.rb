class SocialConnection < ActiveRecord::Base

  belongs_to :source, :polymorphic => true
  belongs_to :target, :polymorphic => true

  scope :by_source_and_target, lambda {|src, trgt|
    where("source_id = ? and source_type = ? and target_id = ? and target_type = ?",
          src.id, src.class.base_class.name, trgt.id, trgt.class.base_class.name) }
end
