require 'strscan'
require_relative 'cue'

module WebVTT
  class FileError < StandardError
  end
end

module WebVTT
  class File
    attr_reader :file
    attr_accessor :cues

    def self.read(file)
      File.new(file)
    end

    def initialize(file)
      @cues = []
      @file = read(file)
      parse
    end

    def parse
      scanner = StringScanner.new(file)
      scanner.skip(/WEBVTT/)

      loop do
        cue = parse_cue(scanner)
        break unless cue
        cues << cue
      end
    end

    private

    def read(file)
      raise FileError, 'FileDoesNotExist' unless ::File.exist?(file)
      ::File.new(file, 'r').read
    end

    def parse_cue(scanner)
      note = parse_text(scanner) if scanner.skip(/\s+NOTE\s+/)
      start, stop = parse_timestamp(scanner)
      text = parse_text(scanner)

      return false unless start && stop && text

      WebVTT::Cue.new(start, stop, text, note)
    end

    def parse_timestamp(scanner)
      scanner.skip(/\s+/)

      timestamp = scanner.scan(/^[0-9:.]+/)

      if scanner.skip(/ --> /)
        return [timestamp, parse_timestamp(scanner)]
      else
        return timestamp
      end
    end

    def parse_text(scanner)
      scanner.skip(/[\s]{1}/)

      text = scanner.scan(/.*/)

      if scanner.skip(/[\s]{1}/) && scanner.peek(1) != "\n"
        return text + ' ' + parse_text(scanner)
      else
        return text
      end
    end
  end
end
