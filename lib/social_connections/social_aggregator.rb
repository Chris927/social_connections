module SocialConnections

  class Feed
    attr_accessor :activities
    def initialize(activities)
      self.activities = activities
    end
  end

  def self.aggregate(who)
    Feed.new(SocialActivity.unseen_activities(who))
  end

end
