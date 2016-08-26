require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "Signup page" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_redirected_to login_url
    assert_not flash.empty?
    # Flash should be now filled with a message prompting to log in to your account
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_redirected_to login_url
    assert_not flash.empty?
  end

  test "should redirect edit when logged in as wrong user" do
    # Log in as Archer
    log_in_as(@other_user)
    #Try to edit Micheal's profile
    get edit_user_path(@user)
    assert_redirected_to root_url
    assert flash.empty?
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    # patch request an update action
    # I am not filling anything as password
    patch user_path(@other_user), params: {
        user: { password:              "",
                password_confirmation: "",
                admin: '1' } }
    assert_not @other_user.admin?
  end

  # test "should redirect destroy when not logged in" do
  #   assert_no_difference 'User.count' do
  #     delete user_path(@user)
  #   end
  #   assert_redirected_to login_url
  # end

  test "should redirect destroy to root url when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end


end
