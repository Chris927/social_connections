require File.dirname(__FILE__) + '/../test/test_helper'

describe "Aggregation" do

  before(:each) do
    load_schema
    @tim = Connectable.create(:name => 'Tim', :email => 'tim@test.com')
    @tom = Connectable.create(:name => 'Tom', :email => 'tom@test.com')
  end

  it "aggregates activities into feeds for specific users" do
    @tim.likes(@tom)
    @tim.comments(@tom, :comment => "This is cool")
    feed_tim = SocialConnections.aggregate(@tim)
    feed_tim.activities.count.should be_>(1)
    feed_tim.activities.each {|a| puts "For Tim: #{a.subject} #{a.verb} #{a.target}, options=#{a.options}"}
    feed_tom = SocialConnections.aggregate(@tom)
    feed_tom.activities.each {|a| puts "For Tom: #{a.subject} #{a.verb} #{a.target}, options=#{a.options}"}
    feed_tom.activities.count.should be_>(1)
  end

  describe DigestMailer do

    before(:each) do
      @tim.likes(@tom)
      @tim.comments(@tom, :comment => "This is boring...")
      @feed_tim = SocialConnections.aggregate(@tim)
      @mail = DigestMailer.digest(@feed_tim, @tim.email)
    end

    it "delivers an email which references all unseen activities ..." do
      @mail.subject.should eq("Digest")
      @mail.to.should eq(["tim@test.com"])
      @mail.from.should eq(["from@example.com"])
      @mail.body.encoded.should match("Hi")
      pending
    end

  end

end
