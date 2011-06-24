require File.dirname(__FILE__) + '/../test/test_helper'

describe "Subjects" do

  before(:each) do
    load_schema
    @sub = Connectable.create(:name => 'Tim')
    @obj = Connectable.create(:name => 'Tom')
  end

  it "can emit activities" do
    activities = @sub.likes(@obj) # what about the 'owner'? everybody 'connected' to the subject *and*
    # the object becomes an owner!
    activities.should_not be_nil
    activities[0].verb.should eql(:likes) 
  end

  it "allows the verbs given, but no other verbs" do
    @sub.likes(@obj)
    @sub.recommends(@obj)
    lambda { @sub.suggests(@obj) }.should raise_error
  end

  it "allows options on activities (e.g. a comment)" do
    activities = @sub.comments(@obj, :comment => 'This is a silly comment on Tom')
    activities[0].options['comment'].should eql('This is a silly comment on Tom')
  end

  it "creates an activity for both subject and object" do
    activities = @sub.likes(@obj)
    activities.select {|a| a.owner == @sub}.should_not be_empty # one activity owned by the subject
    activities.select {|a| a.owner == @obj}.should_not be_empty # ... and one owned by the object
  end

  it "creates activities for those connected to the subject" do
    mary = Connectable.create(:name => 'Mary')
    mary.connect_to(@sub).save # mary is now connected to Tim
    activities = @sub.likes(@obj)
    activities.select {|a| a.owner == mary}.should_not be_empty # Mary gets an activity, because she's connected to Tim
  end

  it "does *not* create activities for those the subject is connected to" do
    mary = Connectable.create(:name => 'Mary')
    @sub.connect_to(mary).save # Tim is now connected to Mary
    activities = @sub.likes(@obj)
    # Mary does not get an activity,
    # because she's *not* connected to Tim (Tim is connected to Mary, though)
    activities.select {|a| a.owner == mary}.should be_empty
  end

  it "creates activities for those connected to the object" do
    anne = Connectable.create(:name => 'Anne')
    anne.connect_to(@obj).save
    activities = @sub.likes(@obj)
    # Anne gets an activity
    activities.select {|a| a.owner == anne}.should_not be_empty
  end

  it "does *not* create an activity for those the subject is connected to" do
    anne = Connectable.create(:name => 'Anne')
    @obj.connect_to(anne).save
    activities = @sub.likes(@obj)
    # Anne does not get an activity
    activities.select {|a| a.owner == anne}.should be_empty
  end

end
