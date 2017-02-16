require 'test_helper'

class CueTest < Minitest::Test
  def setup
    cue_sample = <<~EOC
      1
      03:12.250 --> 03:16.121 line:63% position:72% align:start
      Thank you. Thank you. Thank you.
      This is fantastic.
    EOC
    @cue = WebVTT::Cue.parse(cue_sample)
  end

  def test_cue_identifier
    assert_equal '1', @cue.identifier
  end

  def test_cue_start_timestamp
    assert_equal '00:03:12.250', @cue.start.to_s
  end

  def test_cue_stop_timestamp
    assert_equal '00:03:16.121', @cue.stop.to_s
  end
  
  def test_cue_timing
    assert_equal '00:03:12.250 --> 00:03:16.121', @cue.timing
  end

  def test_cue_text
    assert_equal 'Thank you. Thank you. Thank you. This is fantastic.', @cue.text
  end
end
