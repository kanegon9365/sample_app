require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @base_title = "ぼくのちゅーとりあるぺーじ"
  end
  
  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "ちゅーとりあるぺーじ"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title" , "へるぷ～#{@base_title}"
  end
  
  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title" , "あばうと～#{@base_title}"
  end
  
  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title" , "こんたくと～#{@base_title}"
  end

end
