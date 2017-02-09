module WebVTT
  class Cue
    attr_reader :start, :stop, :text

    def initialize(start, stop, text)
      @start = start
      @stop = stop
      @text = text
    end
  end
end
