require File.dirname(__FILE__) + '/../test/test_helper'

describe "acts_as_connectable" do
  before(:each) do
    @c1 = Connectable.create(:name => 'Anne')
    @c2 = Connectable.create(:name => 'Bob')
  end
  it "defines collection accessors" do
    c = Connectable.create(:name => 'Tim', :email => '2@test.com')
    c.should respond_to(:outgoing_social_connections)
    c.should respond_to(:incoming_social_connections)
  end
  it "fails when connecting to 'nil'" do
    expect { @c1.connect_to(nil) }.to raise_error(ArgumentError)
  end
  it "allows adding connections" do
    @c1.connected_to?(@c2).should be(false)
    @c1.connect_to(@c2)
    @c1.connected_to?(@c2).should be(true)
    @c1.outgoing_social_connections.count.should be(1)
    SocialConnection.outgoing(@c1).count.should be(1)
    @c1.outgoing_social_connections[0].should be_kind_of(SocialConnection)
    @c1.incoming_social_connections.count.should be(0)
    SocialConnection.incoming(@c1).count.should be(0)
    @c2.outgoing_social_connections.count.should be(0)
    SocialConnection.outgoing(@c2).count.should be(0)
    @c2.incoming_social_connections.count.should be(1)
    SocialConnection.incoming(@c2).count.should be(1)
    @c2.incoming_social_connections[0].should be_kind_of(SocialConnection)
  end
  it "allows removing connections" do
    @c1.connect_to(@c2)
    @c1.connected_to?(@c2).should be(true)
    @c1.disconnect_from(@c2)
    @c1.connected_to?(@c2).should be(false)
  end
end
