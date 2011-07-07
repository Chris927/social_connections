module SocialConnections

  class AggregatedActivities
    attr_accessor :activities, :by_verb
    def initialize(activities)
      self.activities = activities
      self.by_verb = activities_by_verb(activities)
    end

    private

    def activities_by_verb(activities)
      by_verb = {}
      activities.collect {|a| a.verb }.uniq.each do |verb| 
        by_verb[verb.to_sym] = activities.select {|b| b.verb == verb }
      end
      by_verb
    end

  end

  class Feed
    attr_accessor :who, :activities, :by_verb, :excluding_self
    def initialize(who)
      self.who = who
      self.activities = SocialActivity.unseen_activities(who)
      aggreg = AggregatedActivities.new(activities)
      self.by_verb = aggreg.by_verb
      self.excluding_self = AggregatedActivities.new( activities.select {|a| a.subject != who} )
    end
  end

  def self.aggregate(who)
    Feed.new(who)
  end

end
