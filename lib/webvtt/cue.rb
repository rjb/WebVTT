module WebVTT
  class Cue
    attr_reader :start, :stop, :text, :note, :identifier

    def initialize(args = {})
      @start = args[:start] || nil
      @stop = args[:stop] || nil
      @text = args[:text] || nil
      @note = args[:note] || nil
      @identifier = args[:identifier] || nil
    end

    def timestamp
      start + ' --> ' + stop
    end
  end
end
