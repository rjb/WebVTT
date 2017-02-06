require 'strscan'

class WebVTT
  class Cue
    attr_reader :start, :stop, :text

    def initialize(start, stop, text)
      @start = start
      @stop = stop
      @text = text
    end

    def timestamp
      start + " --> " + stop
    end

    def to_s
      timestamp + "\n" + text
    end
  end

  attr_reader :cues, :file

  def self.read(file)
    new(file)
  end

  def initialize(file)
    @file = file
    @cues = []
    parse
  end

  def to_s
    cues.map(&:to_s).join
  end

  private

  def parse
    scanner = StringScanner.new(file)

    raise 'UnknownFileType' unless scanner.skip(/WEBVTT/) == 6

    loop do
      result = parse_cue(scanner)
      break unless result
      cues << result
    end
  end

  def parse_cue(scanner)
    scanner.skip(/\s+/)

    if text = parse_text(scanner)
      return text
    elsif timestamp = parse_timestamp(scanner)
      return WebVTT::Cue.new(timestamp[0], timestamp[1], parse_cue(scanner))
    end
  end

  def parse_timestamp(scanner)
    cue = scanner.scan(/^[0-9:.]+ --> [0-9:.]+/)
    cue.split(' --> ') if cue
  end

  def parse_text(scanner)
    scanner.scan(/[[A-Za-z,;'\"\s]+[.?!\s]]+/)
  end
end
