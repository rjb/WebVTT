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

      parse_styling
      parse_cues
    end

    private

    def read(file)
      if !::File.exist?(file)
        raise FileError, 'File does not exist'
      end

      ::File.new(file, 'r').read
    end

    def parse_styling
      @style = parse_style if @scanner.skip(/\s+STYLE\s+/)
    end

    def parse_style
      @scanner.skip(/[\s]{1}/)

      text = @scanner.scan(/.*/)

      if @scanner.skip(/[\s]{1}/) && @scanner.peek(1) != "\n"
        return text + ' ' + parse_style
      else
        return text
      end
    end

    def parse_cues
      @scanner.rest.split("\n\n").each do |data|
        cue = Cue.parse(data)
        cues << cue
      end
    end
  end
end
