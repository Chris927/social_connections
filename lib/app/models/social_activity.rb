class SocialActivity < ActiveRecord::Base

  belongs_to :owner, :polymorphic => true
  belongs_to :subject, :polymorphic => true
  belongs_to :target, :polymorphic => true

  def options
    JSON.parse options_as_json
  end

  def to_s
    "SocialActivity #{subject} #{verb} #{target} (owned by #{owner})"
  end

  def consume
    self.unseen = false
    self.save
  end

  scope :by_subject, lambda {|subject| where("subject_id = ? and subject_type = ?",
                                             subject.id, subject.class.base_class.name)}
  scope :by_owner, lambda {|owner| where("owner_id = ? and owner_type = ?",
                                         owner.id, owner.class.base_class.name)}
  scope :by_target, lambda {|target| where("target_id = ? and target_type = ?",
                                         target.id, target.class.base_class.name)}

  def self.create_activities(subject, verb, object, options = {})
    activities = []
    owners = [ subject, object ]
    owners.concat(options[:additional_recipients]) if options[:additional_recipients]
    owners.concat(subject.incoming_social_connections.collect {|i| i.source })
    owners.concat(object.incoming_social_connections.collect {|i| i.source })

    owners.uniq.each do |owner|
      activities << SocialActivity.create(:owner => owner,
                                          :subject => subject,
                                          :verb => verb,
                                          :target => object,
                                          :options_as_json => options.to_json)
    end
    activities
  end

  def self.unseen_activities(for_whom)
    SocialActivity.where('owner_id = ? and owner_type = ? and unseen = ?',
                         for_whom.id, for_whom.class.name,
                         true).order("created_at DESC")
  end

  def self.exists(subject, verb, object)
    SocialActivity.where('subject_id = ? and subject_type = ? and verb = ? ' +
                         'and target_id = ? and target_type = ?',
                         subject.id, subject.class.name, verb, object.id,
                         object.class.name).exists?
  end

  def self.objects_by_verb_count(object, verb)
    SocialActivity.where('target_id = ? and target_type = ? and verb = ? ' +
                         'and owner_id = ? and owner_type = ?',
                         object.id, object.class.name, verb, object.id,
                         object.class.name).count
  end

end
