require 'test_helper'

class TimestampTest < Minitest::Test
  def setup
    @timestamp = WebVTT::Timestamp.parse('04:12:07.355')
  end

  def test_hours
    assert_equal '04', @timestamp.hours
  end

  def test_minutes
    assert_equal '12', @timestamp.minutes
  end

  def test_seconds
    assert_equal '07', @timestamp.seconds
  end

  def test_milliseconds
    assert_equal '355', @timestamp.milliseconds
  end

  def test_to_s
    assert_equal '04:12:07.355', @timestamp.to_s
  end

  def test_hourless_timestamp
    timestamp = WebVTT::Timestamp.parse('12:07.355')
    assert_equal '00:12:07.355', timestamp.to_s
  end

  def test_invalid_timestamp
    assert_raises('Invalid timestamp.') { WebVTT::Timestamp.parse('aa:bb:cc.000') }
  end
end
