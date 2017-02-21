require 'test_helper'

class CommentTest < Minitest::Test
  def setup
    comment_sample = "NOTE This is a single line note! Hooray ;)"
    @comment = WebVTT::Comment.parse(comment_sample)
  end

  def test_single_line_note
    assert_equal 'This is a single line note! Hooray ;)', @comment.text
  end

  def test_single_line_note_to_s
    assert_equal 'This is a single line note! Hooray ;)', @comment.text.to_s
  end
end

class CommentTwoTest < Minitest::Test
  def setup
    comment_sample = <<~EON
      NOTE
      This is a multiline
      note! Hooray ;)
    EON
    @comment = WebVTT::Comment.parse(comment_sample)
  end

  def test_single_line_note
    assert_equal 'This is a multiline note! Hooray ;)', @comment.text
  end

  def test_single_line_not_to_s
    assert_equal 'This is a multiline note! Hooray ;)', @comment.text.to_s
  end
end
