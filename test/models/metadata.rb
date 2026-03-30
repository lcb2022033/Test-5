require 'test_helper'

class MetadataTest < ActiveSupport::TestCase
  test "metadata title" do
    assert_equal "Example", Metadata.new("<title>Example</title>").title
  end

  test "metadata nil title" do
    assert_nil Metadata.new.title
  end

  test "metadata description" do
    assert_equal "description", Metadata.new("<meta name='description' content='description'>").description
  end

  test "metadata image" do
    assert_equal "image.png", Metadata.new("<meta property='og:image' content='image.png'>").image
  end
end
