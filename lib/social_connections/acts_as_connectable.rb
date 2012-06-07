module SocialConnections

  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    # Enables an ActiveRecord model to act as a connectable.
    # Recognized options:
    # * :verbs - specify a list of constants recognized as verbs.
    #   If none given, :likes is the only default verb.
    def acts_as_connectable(options = {})
      cattr_accessor :acts_as_connectable_options
      send :acts_as_connectable_options=, options
      send :include, InstanceMethods
    end
  end

  module InstanceMethods

    def outgoing_social_connections
      SocialConnection.where("source_id = ? and source_type = ?", self.id, self.class.base_class.name)
    end

    def incoming_social_connections
      SocialConnection.where("target_id = ? and target_type = ?", self.id, self.class.base_class.name)
    end

    def connect_to(other)
      raise ArgumentError.new("other cannot be nil") if other.nil?
      c = SocialConnection.new
      c.target = other
      c.source = self
      c.save
      c
    end

    def disconnect_from(other)
      raise ArgumentError.new("other cannot be nil") if other.nil?
      c = SocialConnection.by_source_and_target(self, other).first
      raise ArgumentError.new("cannot disconnect, connection doesn't exist. source=#{self}, target=#{other}") if c.nil?
      c.destroy
    end

    def connected_to?(other)
      SocialConnection.where("source_id = ? and source_type = ? and target_id = ? and target_type = ?",
                             self.id, self.class.base_class.name, other.id, other.class.base_class.name).exists?
    end

    def acts_as_connectable_verbs
      acts_as_connectable_options[:verbs] || [ :likes ]
    end

    def acts_as_connectable_verb_questions
      acts_as_connectable_verbs.collect {|v| (v.to_s + '?').to_sym }
    end

    def method_missing(name, *args)
      if acts_as_connectable_verbs.include? name
        verb = name
        object = args[0]
        options = args[1] || {}
        options[:additional_recipients] ||= []
        options[:additional_recipients].concat(additional_recipients)
        create_activity(verb, object, options)
      elsif acts_as_connectable_verb_questions.include? name
        verb = name[0..-2]
        object = args[0]
        SocialActivity.exists(self, verb, object)
      elsif verbs.collect {|v| (v.to_s + '_by_count').to_sym }.include? name
        verb = name.to_s.split(/_by_count/)
        object = self
        SocialActivity.objects_by_verb_count(object, verb)
      else
        super
      end
    end

    private

    def create_activity(verb, object, options = {})
      raise ArgumentError.new("object is not a connectable: #{object}") unless object.respond_to? :acts_as_connectable_verbs
      SocialActivity.create_activities(self, verb, object, options)
    end

    def additional_recipients
      additional_recipients = acts_as_connectable_options[:additional_recipients]
      return [] unless additional_recipients
      return self.send(additional_recipients) if self.respond_to?(additional_recipients)
      return additional_recipients
    end

    def verbs
      acts_as_connectable_verbs
    end

  end

end

ActiveRecord::Base.send :include, SocialConnections
