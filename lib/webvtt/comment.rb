module WebVTT
  class Comment
    attr_reader :text
    attr_reader :data

    def self.parse(data)
      comment = Comment.new(data)
      comment.parse
      comment
    end

    def initialize(data)
      @data = data
    end

    def parse
      raise TypeError, 'Invalid note' unless data.match(/^NOTE/)

      @text = data.gsub(/NOTE[\s]{0,}/, '').gsub("\n", ' ').strip
    end

    def to_s
      text
    end
  end
end
