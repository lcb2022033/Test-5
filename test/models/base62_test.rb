require "test_helper"

class Base62Test < ActiveSupport::TestCase
  test "encode 0" do
    assert_equal "0", Base62.encode(0)
  end

  test "encode 1" do
    assert_equal "1", Base62.encode(1)
  end

  test "encode 1024" do
    assert_equal "gw", Base62.encode(1024)
  end

  test "encode 999_999" do
    assert_equal "4c91", Base62.encode(999_999)
  end

  # DECODING TESTS

  test "decode 0" do
    assert_equal 0, Base62.decode("0")
  end

  test "decode 1" do
    assert_equal 1, Base62.decode("1")
  end

  test "decode 1024" do
    assert_equal 1024, Base62.decode("gw")
  end

  test "decode 999_999" do
    assert_equal 999999, Base62.decode("4c91")
  end
end
