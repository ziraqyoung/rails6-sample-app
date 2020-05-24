require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'microposts interface' do
    log_in_as @user
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: '' } }
    end
    assert_select 'div#error_explanation'
    assert_select 'a[href=?]', '/?page=2' # correct pagination link
    # Valid submission
    content = 'This post really ties the room together.'
    image = fixture_file_upload('test/fixtures/files/microposts/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, image: image } }
    end
    assert assigns(:micropost).image.attached?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    assert_select 'a',text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Visit difference user(no delete links)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

  test 'micropost sidebar count' do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # User with zero microposts
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "#{other_user.microposts.count} micropost", response.body
  end
end
