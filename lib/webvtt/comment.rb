module WebVTT
  class Comment
    attr_reader :text

    def initialize(content)
      @text = content
    end

    def to_s
      text
    end
  end
end
