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
      if @scanner.skip(/WEBVTT/).nil?
        raise FileError, 'Not a valid WebVTT file.'
      end

      parse_style
      parse_cues
    end

    private

    def read(file)
      raise FileError, 'File does not exist' unless ::File.exist?(file)
      ::File.new(file, 'r').read
    end

    def parse_style
      @style = parse_text if @scanner.skip(/\s+STYLE\s+/)
    end

    def parse_cues
      loop do
        cue_args = parse_cue
        break unless cue_args
        cues << WebVTT::Cue.new(cue_args)
      end
    end

    def parse_cue
      note = parse_note
      identifier = parse_identifier
      start, stop = parse_timestamp
      text = parse_text

      return false unless start && stop && text

      {
        start: start,
        stop: stop,
        text: text,
        note: note,
        identifier: identifier
      }
    end

    def note_exist?
      @scanner.check(/\s+NOTE\s+/)
    end

    def identifier_exist?
      !@scanner.check(/\s+[0-9:.]+ --> [0-9:.]+/)
    end

    def parse_note
      if note_exist?
        @scanner.skip(/\s+NOTE\s+/)
        parse_text
      end
    end

    def parse_identifier
      if identifier_exist?
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
