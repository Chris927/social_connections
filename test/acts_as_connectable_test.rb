require File.dirname(__FILE__) + '/test_helper'

class ActsAsConnectableTest < ActiveSupport::TestCase

  load_schema

  def setup
    @connectable1 = Connectable.create(:name => 'Anne')
    @connectable2 = Connectable.create(:name => 'Bob')
  end

  test "should define collection accessors" do
    c = Connectable.create(:name => 'Tim', :email => '2@test.com')
    assert c.respond_to?(:outgoing_social_connections) == true, "does not respond to outgoing connections getter."
    assert c.respond_to?(:incoming_social_connections) == true, "does not respond to incoming connections getter."
    # etc.
  end

  test "should not allow nil as 'other'" do
    assert_raise ArgumentError do
      @connectable1.connect_to(nil)
    end
  end

  test "should allow adding connections" do
    @connectable1.connect_to(@connectable2).save
    assert @connectable1.outgoing_social_connections.count == 1
    assert @connectable1.incoming_social_connections.count == 0
    assert @connectable2.outgoing_social_connections.count == 0
    assert @connectable2.incoming_social_connections.count == 1
  end

end
