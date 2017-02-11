require 'strscan'
require_relative 'cue'

module WebVTT
  class File
    attr_reader :file
    attr_reader :style
    attr_accessor :cues

    def self.read(file)
      File.new(file)
    end

    def initialize(file)
      @cues = []
      @file = read(file)
      @scanner = StringScanner.new(@file)
      parse
    end

    def parse
      @scanner.skip(/WEBVTT/)
      parse_style
      parse_cues
    end

    private

    def read(file)
      raise FileError, 'FileDoesNotExist' unless ::File.exist?(file)
      ::File.new(file, 'r').read
    end

    def parse_style
      @style = parse_text if @scanner.skip(/\s+STYLE\s+/)
    end

    def parse_cues
      loop do
        cue = parse_cue
        break unless cue
        cues << cue
      end
    end

    def parse_cue
      note = parse_text if @scanner.skip(/\s+NOTE\s+/)
      identifier = parse_identifier unless @scanner.check(/^[0-9:.\s]+ --> [0-9:.]+/)
      start, stop = parse_timestamp
      text = parse_text

      return false unless start && stop && text

      WebVTT::Cue.new(start, stop, text, note, identifier)
    end

    def parse_identifier
      @scanner.skip(/[\s]{1}/)

      @scanner.scan(/.*/)
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
