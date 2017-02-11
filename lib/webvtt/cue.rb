module WebVTT
  class Cue
    attr_reader :start, :stop, :text, :note, :identifier

    def initialize(start, stop, text, note, identifier)
      @start = start
      @stop = stop
      @text = text
      @note = note
      @identifier = identifier
    end
  end
end
