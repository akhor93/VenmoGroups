require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should not save without access token, refresh token, nor venmo_id" do
    user = User.new
    assert_not user.save
  end
end
