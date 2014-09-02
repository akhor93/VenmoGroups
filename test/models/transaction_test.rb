require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  test "should not save without user, members, amount, note, action, venmo transaction ids" do
    user = User.new
    assert_not user.save
  end
end
