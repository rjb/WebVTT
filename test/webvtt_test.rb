require 'test_helper'

class WebVTTTest < Minitest::Test
  def setup
    @webvtt = WebVTT::File.read('test/speech.vtt')
    @cue = @webvtt.cues.first
    @setting = @cue.settings
  end

  def test_that_it_has_a_version_number
    refute_nil ::WebVTT::VERSION
  end

  def test_cue_identifier
    assert_equal '1', @cue.identifier
  end

  def test_cue_start_timestamp
    assert_equal '00:00:00.000', @cue.start.to_s
  end

  def test_cue_stop_timestamp
    assert_equal '00:00:04.000', @cue.stop.to_s
  end
  
  def test_cue_timing
    assert_equal '00:00:00.000 --> 00:00:04.000', @cue.timing
  end

  def test_cue_text
    assert_equal 'Thank you. Thank you. Thank you. This is fantastic.', @cue.text
  end

  def test_instance_of_cue_setting
    assert_instance_of WebVTT::Setting, @setting
  end

  def test_setting_line
    assert_equal '63%', @setting.line
  end

  def test_setting_position
    assert_equal '72%', @setting.position
  end

  def test_setting_align
    assert_equal 'start', @setting.align
  end
end
