require "test_helper"

class LinksTest < ActionDispatch::IntegrationTest
  test "cannot create link without url" do
    post links_path, params: {link: {url: ""}}
    assert_response :unprocessable_entity
  end

  test "can create link as a guest" do
    post links_path, params: {link: {url: "https://example.com"}}
    assert_response :redirect
  end

  test "can create link as a guest (with turbo response)" do
    assert_difference "Link.count" do
      post links_path(format: :turbo_stream), params: {link: {url: "https://example.com"}}
      assert_response :ok
      assert_nil Link.last.user_id
    end
  end

  test "can create link as a owner/user" do
    user = users(:one)
    sign_in user
    assert_difference "Link.count" do
      post links_path(format: :turbo_stream), params: {link: {url: "https://example.com"}}
      assert_response :ok
      assert_equal user.id, Link.last.user_id
    end
  end
end
