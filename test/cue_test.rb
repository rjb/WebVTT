require 'test_helper'

class CueTest < Minitest::Test
  def test_cue
    cue_sample = <<~EOC
      03:12.250 --> 03:16.121
      Thank you. Thank you. Thank you.
    EOC

    cue = WebVTT::Cue.parse(cue_sample)

    assert_nil cue.identifier
    assert_equal '00:03:12.250', cue.start.to_s
    assert_equal '00:03:16.121', cue.stop.to_s
    assert_equal '00:03:12.250 --> 00:03:16.121', cue.timing
    assert_equal 'Thank you. Thank you. Thank you.', cue.text

    assert_nil cue.settings
  end

  def test_cue_with_id
    cue_sample = <<~EOC
      1
      03:12.250 --> 03:16.121
      Thank you. Thank you. Thank you.
      This is fantastic.
    EOC

    cue = WebVTT::Cue.parse(cue_sample)

    assert_equal '1', cue.identifier
    assert_equal '00:03:12.250', cue.start.to_s
    assert_equal '00:03:16.121', cue.stop.to_s
    assert_equal '00:03:12.250 --> 00:03:16.121', cue.timing
    assert_equal 'Thank you. Thank you. Thank you. This is fantastic.', cue.text

    assert_nil cue.settings
  end

  def test_que_with_id_and_setting
    cue_sample = <<~EOC
      1
      03:12.250 --> 03:16.121 line:63% position:72% align:start
      Thank you. Thank you. Thank you.
      This is fantastic.
    EOC

    cue = WebVTT::Cue.parse(cue_sample)

    assert_equal '1', cue.identifier
    assert_equal '00:03:12.250', cue.start.to_s
    assert_equal '00:03:16.121', cue.stop.to_s
    assert_equal '00:03:12.250 --> 00:03:16.121', cue.timing
    assert_equal 'Thank you. Thank you. Thank you. This is fantastic.', cue.text

    assert_instance_of WebVTT::Setting, cue.settings
  end
end
