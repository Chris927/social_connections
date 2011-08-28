class MuteAndCuriousGuest < ActiveRecord::Base

  acts_as_connectable :verbs => []

  def self.activities
    SocialConnections.aggregate(self.instance).activities
  end

  def self.instance
    if MuteAndCuriousGuest.count == 0
      MuteAndCuriousGuest.create
    else
      MuteAndCuriousGuest.first
    end
  end

end
