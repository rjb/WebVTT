require 'test_helper'

class CommentTest < Minitest::Test
  def test_single_line_comment
    note = "NOTE This is a single line note! Hooray ;)"
    comment = WebVTT::Comment.parse(note)

    assert_equal 'This is a single line note! Hooray ;)', comment.text
    assert_equal 'This is a single line note! Hooray ;)', comment.to_s
  end

  def test_multiline_comment
    note = <<~EON
      NOTE
      This is a multiline
      note! Hooray ;)
    EON
    comment = WebVTT::Comment.parse(note)

    assert_equal 'This is a multiline note! Hooray ;)', comment.text
    assert_equal 'This is a multiline note! Hooray ;)', comment.to_s
  end

  def test_invalid_comment
    note = "This is not a valid note."
    assert_raises(WebVTT::TypeError) { WebVTT::Comment.parse(note) }
  end
end
