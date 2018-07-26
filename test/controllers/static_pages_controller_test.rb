require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @base_title = "ぼくのちゅーとりあるぺーじ"
  end
  
  test "should get root" do
    get root_url
    assert_response :success
    assert_select "title", "ちゅーとりあるぺーじ"
  end
  
  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "ちゅーとりあるぺーじ"
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title" , "へるぷ～#{@base_title}"
  end
  
  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title" , "あばうと～#{@base_title}"
  end
  
  test "should get contact" do
    get static_pages_contact_url
    assert_response :success
    assert_select "title" , "こんたくと～#{@base_title}"
  end

end
