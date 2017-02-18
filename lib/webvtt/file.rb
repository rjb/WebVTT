require 'strscan'
require 'webvtt/cue'
require 'webvtt/region'
require 'webvtt/comment'

module WebVTT
  class File
    attr_reader :cues
    attr_reader :file
    attr_reader :style
    attr_reader :region
    attr_reader :comments

    def self.read(file)
      File.new(file)
    end

    def initialize(file)
      @cues = []
      @comments = []
      @file = read(file)
      @scanner = StringScanner.new(@file)
      parse
    end

    def parse
      if @scanner.skip(/WEBVTT/).nil?
        raise FileError, 'Not a valid WebVTT file.'
      end

      parse_styling
      parse_rest
    end

    private

    def read(file)
      if !::File.exist?(file)
        raise FileError, 'File does not exist'
      end

      ::File.read(file)
    end

    def parse_styling
      @style = parse_style if @scanner.skip(/\s+STYLE\s+/)
    end

    def parse_style
      @scanner.skip(/\s+/)

      text = @scanner.scan(/.*/)

      if @scanner.skip(/[\s]{1}/) && @scanner.peek(1) != "\n"
        return text + ' ' + parse_style
      else
        return text
      end
    end

    def parse_rest
      @scanner.skip(/\s+/)

      @scanner.rest.split("\n\n").each do |content|
        if content.match(/NOTE/)
          @comments << Comment.parse(content)
        elsif content.match(/REGION/)
          @region = Region.parse(content)
        else
          @cues << Cue.parse(content)
        end
      end
    end
  end
end
