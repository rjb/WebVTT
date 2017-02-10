module WebVTT
  class Cue
    attr_reader :start, :stop, :text, :note

    def initialize(start, stop, text, note)
      @start = start
      @stop = stop
      @text = text
      @note = note
    end
  end
end
