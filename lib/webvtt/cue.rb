module WebVTT
  class Cue
    attr_reader :start, :stop, :text, :note, :identifier, :content

    def self.parse(content)
      cue = Cue.new(content)
      cue.parse
      cue
    end

    def initialize(content)
      @content = content
      @scanner = StringScanner.new(content)
    end

    def parse
      @note = parse_note
      @identifier = parse_identifier
      @start, @stop = parse_timestamp
      @text = parse_text
    end

    def timestamp
      start + ' --> ' + stop if start && stop
    end

    private

    def parse_note
      parse_text if @scanner.skip(/\s+NOTE\s+/)
    end

    def parse_identifier
      if !@scanner.check(/\s+[0-9:.]+ --> [0-9:.]+/)
        @scanner.skip(/\s+/)
        @scanner.scan(/.*/)
      end
    end

    def parse_timestamp
      @scanner.skip(/\s+/)

      timestamp = @scanner.scan(/^[0-9:.]+/)

      if @scanner.skip(/ --> /)
        return [timestamp, parse_timestamp]
      else
        return timestamp
      end
    end

    def parse_text
      @scanner.skip(/[\s]{1}/)

      text = @scanner.scan(/.*/)

      if @scanner.skip(/[\s]{1}/) && @scanner.peek(1) != "\n"
        return text + ' ' + parse_text
      else
        return text
      end
    end
  end
end
