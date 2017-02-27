require 'test_helper'

class RegionTest < Minitest::Test
  def setup
    region_sample = <<~EOR
      REGION
      id:1
      width:40%
      lines:3
      regionanchor:0%,100%
      viewportanchor:10%,90%
      scroll:up
    EOR
    @region = WebVTT::Region.parse(region_sample)
  end

  def test_invalid_region
    sample = <<~EOR
      REGION id:1
      width:40%
      lines:3
      regionanchor:0%,100%
      viewportanchor:10%,90%
      scroll:up
    EOR
    assert_raises(WebVTT::TypeError) { WebVTT::Region.parse(sample) }
    assert_raises(WebVTT::ArgumentError) { WebVTT::Region.parse("REGION\nid:1\n:30%") }
  end

  def test_valid_identifier
    assert_equal 1, @region.id
  end

  def test_empty_identifier
    assert_empty WebVTT::Region.parse("REGION\n").id
    assert_empty WebVTT::Region.parse("REGION\nid:").id
  end

  def test_invalid_identifier
    assert_raises(WebVTT::ArgumentError) { WebVTT::Region.parse("REGION\nid:1-->2") }
  end

  def test_valid_width
    assert_equal '40%', @region.width
  end

  def test_empty_width
    assert_empty WebVTT::Region.parse("REGION\n").width
    assert_empty WebVTT::Region.parse("REGION\nwidth:").width
  end

  def test_invalid_width
    assert_raises(WebVTT::ArgumentError) { WebVTT::Region.parse("REGION\nwidth:22") }
  end

  def test_lines
    assert_equal 3, @region.lines
  end

  def test_empty_lines
    assert_empty WebVTT::Region.parse("REGION\n").lines
    assert_empty WebVTT::Region.parse("REGION\nlines:").lines
  end

  def test_invalid_lines
    assert_raises(WebVTT::ArgumentError) { WebVTT::Region.parse("REGION\nlines:abc") }
  end

  def test_region_anchor
    assert_equal '0%,100%', @region.region_anchor
  end

  def test_empty_region_anchor
    assert_empty WebVTT::Region.parse("REGION\n").region_anchor
    assert_empty WebVTT::Region.parse("REGION\nregionanchor:").region_anchor
  end

  def test_invalid_region_anchor
    assert_raises(WebVTT::ArgumentError) { WebVTT::Region.parse("REGION\nregionanchor:12,12") }
    assert_raises(WebVTT::ArgumentError) { WebVTT::Region.parse("REGION\nregionanchor:12%,12") }
    assert_raises(WebVTT::ArgumentError) { WebVTT::Region.parse("REGION\nregionanchor:12,12%") }
    assert_raises(WebVTT::ArgumentError) { WebVTT::Region.parse("REGION\nregionanchor:120%,120%") }
    assert_raises(WebVTT::ArgumentError) { WebVTT::Region.parse("REGION\nregionanchor:12%,120%") }
    assert_raises(WebVTT::ArgumentError) { WebVTT::Region.parse("REGION\nregionanchor:120%,12%") }
  end

  def test_viewport_anchor
    assert_equal '10%,90%', @region.viewport_anchor
  end

  def test_empty_viewport_anchor
    assert_empty WebVTT::Region.parse("REGION\n").viewport_anchor
    assert_empty WebVTT::Region.parse("REGION\nviewportanchor:").viewport_anchor
  end

  def test_invalid_viewport_anchor
    assert_raises(WebVTT::ArgumentError) { WebVTT::Region.parse("REGION\nviewportanchor:63,20") }
    assert_raises(WebVTT::ArgumentError) { WebVTT::Region.parse("REGION\nviewportanchor:12%,12") }
    assert_raises(WebVTT::ArgumentError) { WebVTT::Region.parse("REGION\nviewportanchor:12,12%") }
    assert_raises(WebVTT::ArgumentError) { WebVTT::Region.parse("REGION\nviewportanchor:120%,120%") }
    assert_raises(WebVTT::ArgumentError) { WebVTT::Region.parse("REGION\nviewportanchor:120%,12%") }
    assert_raises(WebVTT::ArgumentError) { WebVTT::Region.parse("REGION\nviewportanchor:12%,120%") }
  end

  def test_scroll
    assert_equal 'up', @region.scroll
  end

  def test_empty_scroll
    assert_empty WebVTT::Region.parse("REGION\n").scroll
    assert_empty WebVTT::Region.parse("REGION\nscroll:").scroll
  end

  def test_invalid_scroll
    assert_raises(WebVTT::ArgumentError) { WebVTT::Region.parse("REGION\nscroll:DOWN") }
  end
end
