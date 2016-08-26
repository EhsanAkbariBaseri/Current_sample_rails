require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "Testing the full_title doing right" do
    assert_equal full_title, "Ehsan Akbari\'s Personal Website"
    assert_equal full_title("Help"),"Help | Ehsan Akbari\'s Personal Website"
  end
end