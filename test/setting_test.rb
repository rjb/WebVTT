require 'test_helper'

class Minitest::Test
  def setup
    setting_sample = 'line:63% position:72% align:start size:23% vertical:rl'
    @setting = WebVTT::Setting.parse(setting_sample)
  end

  def test_valid_line
    assert_equal '63%', @setting.line
  end

  def test_valid_size
    assert_equal '23%', @setting.size
  end

  def test_valid_align
    assert_equal 'start', @setting.align
  end

  def test_valid_position
    assert_equal '72%', @setting.position
  end

  def test_valid_vertical
    assert_equal 'rl', @setting.vertical
  end

  def test_to_s
    assert_equal 'line:63% position:72% align:start size:23% vertical:rl', @setting.to_s
  end

  def test_invalid_size
    assert_raises('Invalid size value.') { @setting.size = '700%' }
  end

  def test_invalid_align
    assert_raises('Invalid align value.') { @sedding.align = 'top' }
  end

  def test_invalid_position
    assert_raises('Invalid position value.') { @setting.position = '101%' }
  end

  def test_invalud_vertical
    assert_raises('Invalid vertical value.') { @setting.vertical = 'tr' }
  end
end
