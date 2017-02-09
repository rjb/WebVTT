require 'strscan'
require_relative 'cue'

module WebVTT
  class File
    attr_reader :file
    attr_accessor :cues

    def self.read(file)
      scanner = StringScanner.new(file)
      scanner.skip(/WEBVTT/)

      webvtt = File.new

      loop do
        cue = parse_cue(scanner)
        break unless cue
        webvtt.cues << cue
      end

      webvtt
    end

    def initialize
      @cues = []
    end

    def self.parse_cue(scanner)
      start, stop = parse_timestamp(scanner)
      text = parse_text(scanner)

      return false unless start && stop && text

      WebVTT::Cue.new(start, stop, text)
    end

    def self.parse_timestamp(scanner)
      scanner.skip(/\s+/)

      timestamp = scanner.scan(/^[0-9:.]+/)
      
      if scanner.skip(/ --> /)
        return [timestamp, parse_timestamp(scanner)]
      else
        return timestamp
      end
    end

    def self.parse_text(scanner)
      scanner.skip(/[\s]{1}/)

      text = scanner.scan(/.*/)

      if scanner.skip(/[\s]{1}/) && scanner.peek(1) != "\n"
        return [text, parse_text(scanner)].flatten
      else
        return text
      end
    end
  end
end
