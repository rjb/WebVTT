require 'strscan'

class WebVTT
  attr_accessor :cues

  def initialize
    @cues = []
  end
end

class Cue
  attr_reader :start, :stop, :text

  def initialize(start, stop, text)
    @start = start
    @stop = stop
    @text = text
  end
end

def parse_webvtt(webvtt)
  scanner = StringScanner.new(webvtt)
  scanner.skip(/WEBVTT/)
  
  webvtt = WebVTT.new()
  
  loop do
    cue = parse_cue(scanner)
    break unless cue
    webvtt.cues << cue
  end
  
  webvtt
end

def parse_cue(scanner)
  start, stop = parse_timestamp(scanner)
  text = parse_text(scanner)

  return false unless start && stop && text

  Cue.new(start, stop, text)
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
    return [text, parse_text(scanner)].flatten
  else
    return text
  end
end
