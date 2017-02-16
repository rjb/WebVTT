require 'test_helper'

class WebVTTTest < Minitest::Test
  def setup
    @webvtt = WebVTT::File.read('test/speech.vtt')
  end

  def test_that_it_has_a_version_number
    refute_nil ::WebVTT::VERSION
  end

  def test_cues_count
    assert_equal 2, @webvtt.cues.count
  end

  def test_instances_of_cue
    @webvtt.cues.each do |cue|
      assert_instance_of WebVTT::Cue, cue
    end
  end

  def test_comments_count
    assert_equal 1, @webvtt.comments.count
  end

  def test_instances_of_note
    @webvtt.comments.each do |comment|
      assert_instance_of WebVTT::Comment, comment
    end
  end

  def test_instance_of_region
    assert_instance_of WebVTT::Region, @webvtt.region
  end

  def test_style
    style = 
      '::cue(v[voice="Esme"]) { color: cyan } ' \
      '::cue(v[voice="Mary"]) { color: lime } ' \
      '::cue(i) { font-style: italic }'
    assert_equal style, @webvtt.style
  end
end
