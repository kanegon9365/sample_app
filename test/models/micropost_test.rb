require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    # このコードは慣習的に正しくない
    @micropost = @user.microposts.build(content:"テスト投稿")
  end

  test "should be valid" do  
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  
  test "content should be presend" do
   @micropost.content = ""
   assert_not @micropost.valid?
  end
  
  test "content should be at most 140 characters" do
    @micropost.content = "a"*141
    assert_not @micropost.valid?
  end
  
  test "order should be most recent first" do
    #モデルで新しい投稿が上に来るようにバリデーションが設定されているので既に最新の投稿と上にある投稿が一致するはず。それをテストしている。
    assert_equal microposts(:most_recent),Micropost.first  
  end
  
end
