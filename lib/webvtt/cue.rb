require_relative 'timestamp'

module WebVTT
  class Cue
    attr_reader :start
    attr_reader :stop
    attr_reader :text
    attr_reader :data
    attr_reader :identifier

    def self.parse(data)
      cue = Cue.new(data)
      cue.parse
      cue
    end

    def initialize(data)
      @data = data
      @scanner = StringScanner.new(data)
    end

    def parse
      @identifier = parse_identifier

      if stamp = parse_timestamp
        @start, @stop = stamp.map do |stamp|
          WebVTT::Timestamp.parse(stamp) if stamp
        end
      end

      @text = parse_text
    end

    def timestamp
      start.join(stop) if start && stop
    end

    private

    def parse_identifier
      @scanner.skip(/\s+/)

      if !@scanner.check(/[0-9:.]+ --> [0-9:.]+/) && !@scanner.check(/NOTE/)
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
