require 'test_helper'

class SocialConnectionTest < ActiveSupport::TestCase
  load_schema

  test "SocialConnection can be instantiated" do
    assert_kind_of SocialConnection, SocialConnection.new
  end
end

