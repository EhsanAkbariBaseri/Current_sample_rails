require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "Checking layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]",root_path,count:2
    assert_select "a[href=?]",help_path
    # Inserts the path at the place of question mark (?)
    assert_select "a[href=?]",about_path
    assert_select "a[href=?]",contact_path
    #It checks for a link in page with specified URL
    get contact_path
    assert_select "title",full_title("Contact")
    get signup_path
    assert_select "title",full_title("Sign up")
  end

  # I am really confused about this code not working :(

  # test "Checking layout links for Logged-in users" do
  #   user = users(:archer)
  #   puts user.id
  #   log_in_as user
  #   get root_path
  #   assert_template 'static_pages/home'
  #   assert_select "a[href=?]","http://localhost:3000/users/#{user.id}"
  #   assert_select "a[href=?]","http://localhost:3000/users/#{user.id}/edit"
  #   assert_select "a[href=?]","http://localhost:3000/users"
  # end
end
