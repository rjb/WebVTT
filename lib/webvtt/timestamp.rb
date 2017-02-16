module WebVTT
  class Timestamp
    attr_reader :hours
    attr_reader :minutes
    attr_reader :seconds
    attr_reader :milliseconds

    def self.parse(data)
      timestamp = Timestamp.new(data)
      timestamp.parse
      timestamp
    end

    def initialize(data)
      @data = data
    end

    def parse
      @hours, @minutes, @seconds, @milliseconds = parse_timestamp
    end

    def to_s
      hours + ':' + minutes + ':' + seconds + '.' + milliseconds
    end

    private

    def parse_timestamp
      stamp = @data.match(/([0-9]{0,2}):{0,1}([0-9]{2}):([0-9]{2}).([0-9]{3})/)

      if stamp.nil?
        raise 'Invalid timestamp.'
      end

      hours = stamp[1].empty? ? '00' : stamp[1]

      [hours, stamp[2], stamp[3], stamp[4]]
    end
  end
end
