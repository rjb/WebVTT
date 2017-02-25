require 'test_helper'

class WebVTTTest < Minitest::Test
  def test_cues_count
    webvtt = WebVTT::File.read('test/vtt/valid.vtt')
    assert_equal 2, webvtt.cues.count
  end

  def test_cue_indentifier
    webvtt = WebVTT::File.read('test/vtt/valid.vtt')
    assert_equal '1', webvtt.cues.first.identifier
    assert_equal 'Identifier 2', webvtt.cues.last.identifier
  end

  def test_cue_timing
    webvtt = WebVTT::File.read('test/vtt/valid.vtt')
    cues = webvtt.cues

    assert_equal '00:00:00.000', webvtt.cues.first.start.to_s
    assert_equal '00:00:08.000', webvtt.cues.last.stop.to_s

    assert_equal '00:00:00.000 --> 00:00:04.000', cues.first.timing
    assert_equal '00:00:05.000 --> 00:00:08.000', cues.last.timing
  end

  def test_cue_setting
    webvtt = WebVTT::File.read('test/vtt/valid.vtt')
    settings = webvtt.cues.first.settings

    settings_string = 'line:63% position:72% align:start size:23% vertical:lr'

    assert_equal '63%', settings.line
    assert_equal '72%', settings.position
    assert_equal 'start', settings.align
    assert_equal '23%', settings.size
    assert_equal 'lr', settings.vertical

    assert_equal settings_string, settings.to_s
  end

  def test_region
    webvtt = WebVTT::File.read('test/vtt/valid.vtt')
    region = webvtt.region

    assert_equal 1, region.id
    assert_equal '40%', region.width
    assert_equal 3, region.lines
    assert_equal '0%,100%', region.region_anchor
    assert_equal '10%,90%', region.viewport_anchor
    assert_equal 'up', region.scroll
  end

  def test_comment
    webvtt = WebVTT::File.read('test/vtt/valid.vtt')
    comments = webvtt.comments

    multi_line = "Ray Bradbury's Commencement Speech to the Caltech Class of 2000."
    single_line = "End of the speech."

    assert_equal multi_line, comments.first.text
    assert_equal multi_line, comments.first.to_s

    assert_equal single_line, comments.last.text
    assert_equal single_line, comments.last.to_s
  end

  def test_style
    webvtt = WebVTT::File.read('test/vtt/valid.vtt')

    style =
      '::cue(v[voice="Esme"]) { color: cyan } ' \
      '::cue(v[voice="Mary"]) { color: lime }'

    assert_equal style, webvtt.style
  end

  def test_invalid_region
    assert_raises(WebVTT::FileError) do
      WebVTT::File.read('test/nofile.vtt')
    end
  end

  def test_invalid_webvtt_file
    assert_raises(WebVTT::FileError) do
      WebVTT::File.read('test/vtt/invalid.vtt')
    end
  end

  def test_invalid_region
    assert_raises(WebVTT::TypeError) do
      WebVTT::File.read('test/vtt/invalid_region.vtt')
    end
  end
end
