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
    @region = WebVTT::Region.new(region_sample)
  end

  def test_id
    assert_equal 1, @region.id
  end

  def test_width
    assert_equal '40%', @region.width
  end

  def test_lines
    assert_equal 3, @region.lines
  end

  def test_region_anchor
    assert_equal '0%,100%', @region.region_anchor
  end

  def test_viewport_anchor
    assert_equal '10%,90%', @region.viewport_anchor
  end

  def test_scroll
    assert_equal 'up', @region.scroll
  end
end

class RegionTwoTest < Minitest::Test
  def setup
    region_sample = "REGION\n\n"
    @region = WebVTT::Region.new(region_sample)
  end

  def test_id
    assert_nil @region.id
  end

  def test_width
    assert_nil @region.width
  end

  def test_lines
    assert_nil @region.lines
  end

  def test_region_anchor
    assert_nil @region.region_anchor
  end

  def test_viewport_anchor
    assert_nil @region.viewport_anchor
  end

  def test_scroll
    assert_nil @region.scroll
  end
end
