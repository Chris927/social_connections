
describe MuteAndCuriousGuest do
  it "has a single instance" do
    MuteAndCuriousGuest.instance.should_not be(nil)
  end
  it "can connect to things" do
    tim = Connectable.new(:name => 'Tim')
    MuteAndCuriousGuest.instance.connect_to(tim)
  end
  it "receives activities when something happens with a connected thing" do
    tim = Connectable.new(:name => 'Tim')
    tom = Connectable.new(:name => 'Tom')
    MuteAndCuriousGuest.instance.connect_to(tim)
    tim.comments(tom)
    SocialConnections.aggregate(MuteAndCuriousGuest.instance).activities.count.should be(1)
  end
end
