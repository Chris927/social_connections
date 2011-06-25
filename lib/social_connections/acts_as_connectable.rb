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
      SocialConnection.where("source_id = ? and source_type = ?", self.id, self.class.name)
    end

    def incoming_social_connections
      SocialConnection.where("target_id = ? and target_type = ?", self.id, self.class.name)
    end

    def connect_to(other)
      raise ArgumentError.new("other cannot be nil") if other.nil?
      c = SocialConnection.new
      c.target = other
      c.source = self
      c
    end

    def acts_as_connectable_verbs
      acts_as_connectable_options[:verbs] || [ :likes ]
    end

    def method_missing(name, *args)
      if acts_as_connectable_verbs.include? name
        verb = name
        object = args[0]
        options = args[1] || {}
        create_activity(verb, object, options)
      else
        super
      end
    end

    private

    def create_activity(verb, object, options = {})
      SocialActivity.create_activities(self, verb, object, options)
    end

  end

end

ActiveRecord::Base.send :include, SocialConnections
