require 'test_helper'

class WebVTTTest < Minitest::Test
  def setup
    @webvtt = WebVTT::File.read('test/speech.vtt')
    @cue = @webvtt.cues.first
    @setting = @cue.settings
    @region = @webvtt.region
    @comment = @webvtt.comments.first
  end

  def test_that_it_has_a_version_number
    refute_nil ::WebVTT::VERSION
  end

  def test_raises_file_error
    assert_raises(WebVTT::FileError) { WebVTT::File.read('nothing.vtt') }
  end

  def test_style
    style = 
      '::cue(v[voice="Esme"]) { color: cyan } ' \
      '::cue(v[voice="Mary"]) { color: lime }'
    assert_equal style, @webvtt.style
  end

  def test_cues_count
    assert_equal 2, @webvtt.cues.count
  end

  def test_cues_instances_of_cue
    @webvtt.cues.each do |cue|
      assert_instance_of WebVTT::Cue, cue
    end
  end

  def test_cue_identifier
    assert_equal '1', @cue.identifier
  end

  def test_cue_start_timestamp
    assert_output('Start: 00:00:00.000') { print "Start: #{@cue.start}" }
  end

  def test_cue_stop_timestamp
    assert_output('Stop: 00:00:04.000') { print "Stop: #{@cue.stop}" }
  end
  
  def test_cue_timing
    timing = 'Timing: 00:00:00.000 --> 00:00:04.000'
    assert_output(timing) { print "Timing: #{@cue.timing}" }
  end

  def test_cue_text
    text =
      'Thank you. Thank you. Thank you. ' \
      'This is fantastic.'
    assert_equal text, @cue.text
  end

  def test_cue_settings_instance_of_setting
    assert_instance_of WebVTT::Setting, @setting
  end

  def test_cue_settings_valid_line
    assert_equal '63%', @setting.line
  end

  def test_cue_settings_valid_size
    assert_equal '23%', @setting.size
  end

  def test_cue_settings_valid_align
    assert_equal 'start', @setting.align
  end

  def test_cue_settings_valid_position
    assert_equal '72%', @setting.position
  end

  def test_cue_settings_valid_vertical
    assert_equal 'lr', @setting.vertical
  end

  def test_cue_settings_to_s
    setting = 
      'line:63% ' \
      'position:72% ' \
      'align:start ' \
      'size:23% ' \
      'vertical:lr'
    assert_equal setting, @setting.to_s
  end

  def test_comments_count
    assert_equal 1, @webvtt.comments.count
  end

  def test_instances_of_note
    @webvtt.comments.each do |comment|
      assert_instance_of WebVTT::Comment, comment
    end
  end

  def test_comment_note
    text = 
      "Ray Bradbury's Commencement Speech " \
      "to the Caltech Class of 2000."
    assert_equal text, @comment.text
  end

  def test_comment_note_to_s
    text = 
      "Ray Bradbury's Commencement Speech " \
      "to the Caltech Class of 2000."
    assert_equal text, @comment.text.to_s
  end

  def test_instance_of_region
    assert_instance_of WebVTT::Region, @region
  end

  def test_region_id
    assert_equal 1, @region.id
  end

  def test_region_width
    assert_equal '40%', @region.width
  end

  def test_region_lines
    assert_equal 3, @region.lines
  end

  def test_region_region_anchor
    assert_equal '0%,100%', @region.region_anchor
  end

  def test_region_viewport_anchor
    assert_equal '10%,90%', @region.viewport_anchor
  end

  def test_region_scroll
    assert_equal 'up', @region.scroll
  end
end
