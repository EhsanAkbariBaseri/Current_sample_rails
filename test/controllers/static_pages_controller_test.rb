require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  private
  def setup
    @base_title = "Ehsan Akbari\'s Personal Website"
  end

  test "should direct us to root" do
    get root_url
    assert_response :success
  end


  test "should get home" do
    get root_path
    assert_response :success
    assert_select 'title',"#{@base_title}"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select 'title',"Help | #{@base_title}"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select 'title',"About | #{@base_title}"
  end
  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select 'title',"Contact | #{@base_title}"
  end

end