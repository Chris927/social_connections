require File.dirname(__FILE__) + '/../test/test_helper'

describe "Aggregation" do

  before(:each) do
    @tim = Connectable.create(:name => 'Tim', :email => 'tim@test.com')
    @tom = Connectable.create(:name => 'Tom', :email => 'tom@test.com')
  end

  it "aggregates activities into feeds for specific users" do
    @tim.likes(@tom)
    @tim.comments(@tom, :comment => "This is cool")
    feed_tim = SocialConnections.aggregate(@tim)
    feed_tim.activities.count.should be_>(1)
    feed_tom = SocialConnections.aggregate(@tom)
    feed_tom.activities.count.should be_>(1)
  end

  it "aggregates activities for 'passive' users" do
    stalker = Connectable.create(:name => 'Tony', :email => 'tony@test.com')
    stalker.connect_to(@tom)
    aggregate = SocialConnections.aggregate(stalker)
    aggregate.activities.count.should eq(0)
    @tim.comments(@tom, :comment => 'Tony is listening...')
    aggregate = SocialConnections.aggregate(stalker)
    aggregate.activities.count.should eq(1)
  end

  describe "When Tim and Tom interacted" do

    before(:each) do
      @tim.likes(@tom)
      @tim.comments(@tom, :comment => "Got news for you")
      @tom.comments(@tim, :comment => "What news?")
    end

    it "aggregates unseen activities only" do
      feed_tim = SocialConnections.aggregate(@tim)
      feed_tim.activities.count.should be_>(1)
      feed_tim.activities.each { |a| a.consume }
      SocialConnections.aggregate(@tim).activities.count.should be(0)
      SocialConnections.aggregate(@tom).activities.count.should be_>(0)
    end

  end

  describe DigestMailer do

    before(:each) do
      @tim.likes(@tom)
      @tim.comments(@tom, :comment => "This is boring...")
      @tom.comments(@tim, :comment => "Maybe boring, but it documents this gem :)")
      @feed_tim = SocialConnections.aggregate(@tim)
      @mail = DigestMailer.digest(@feed_tim, @tim.email).deliver
    end

    it "determines activities and activities by verb" do
      @feed_tim.activities.count.should eql(3)
      @feed_tim.by_verb.should_not eql(nil)
      @feed_tim.by_verb[:comments].count.should eql(2)
      @feed_tim.by_verb[:likes].count.should eql(1)
      @feed_tim.by_verb[:recommends].blank?.should be(true)
      @feed_tim.excluding_self.by_verb[:comments].count.should eql(1)
      @feed_tim.excluding_self.by_verb[:likes].blank?.should be(true)
    end

    it "delivers an email" do
      @mail.subject.should eq("Digest")
      @mail.to.should eq(["tim@test.com"])
      @mail.from.should eq(["from@example.com"])
      @mail.body.encoded.should match("Hi")
    end

  end

end
