require File.dirname(__FILE__) + '/../test/test_helper'

describe "Social Activities" do

  before(:each) do
    @sub = Connectable.create(:name => 'Tim')
    @obj = Connectable.create(:name => 'Tom')
  end

  describe "Subjects" do

    it "can emit activities" do
      activities = @sub.likes(@obj) # what about the 'owner'? everybody 'connected' to the subject *and*
      # the object becomes an owner!
      activities.should_not be_nil
      activities[0].verb.should eql(:likes) 
    end

    it "allow the verbs given, but no other verbs" do
      @sub.likes(@obj)
      @sub.recommends(@obj)
      lambda { @sub.suggests(@obj) }.should raise_error
    end

    it "know if subject/verb/object occured before" do
      @sub.likes @obj
      @sub.likes?(@obj).should be_true
      @sub.recommends?(@obj).should be_false
      @sub.recommends @obj
      @sub.recommends?(@obj).should be_true
    end

    it "count by how many an object is liked by (or any other verb)" do
      @obj.likes_by_count.should eql(0)
      @sub.likes @obj
      @obj.likes_by_count.should eql(1)
    end

  end

  it "allow options on activities (e.g. a comment)" do
    activities = @sub.comments(@obj, :comment => 'This is a silly comment on Tom')
    activities[0].options['comment'].should eql('This is a silly comment on Tom')
  end

  it "create an activity for both subject and object" do
    activities = @sub.likes(@obj)
    activities.select {|a| a.owner == @sub}.should_not be_empty # one activity owned by the subject
    activities.select {|a| a.owner == @obj}.should_not be_empty # ... and one owned by the object
  end

  it "create activities for those connected to the subject" do
    mary = Connectable.create(:name => 'Mary')
    mary.connect_to(@sub) # mary is now connected to Tim
    activities = @sub.likes(@obj)
    activities.select {|a| a.owner == mary}.should_not be_empty # Mary gets an activity, because she's connected to Tim
  end

  it "do *not* create activities for those the subject is connected to" do
    mary = Connectable.create(:name => 'Mary')
    @sub.connect_to(mary) # Tim is now connected to Mary
    activities = @sub.likes(@obj)
    # Mary does not get an activity,
    # because she's *not* connected to Tim (Tim is connected to Mary, though)
    activities.select {|a| a.owner == mary}.should be_empty
  end

  it "create activities for those connected to the object" do
    anne = Connectable.create(:name => 'Anne')
    anne.connect_to(@obj)
    activities = @sub.likes(@obj)
    # Anne gets an activity
    activities.select {|a| a.owner == anne}.should_not be_empty
  end

  it "do *not* create an activity for those the subject is connected to" do
    anne = Connectable.create(:name => 'Anne')
    @obj.connect_to(anne)
    activities = @sub.likes(@obj)
    # Anne does not get an activity
    activities.select {|a| a.owner == anne}.should be_empty
  end

end
