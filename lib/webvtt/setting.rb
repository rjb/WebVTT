module WebVTT
  class Setting
    PERCENTAGE_VALUES = ('0'..'100')
    VALID_VERTICAL_VALUES = %w(rl lr)
    VALID_ALIGN_VALUES = %w(start middle end)

    attr_reader :data
    attr_reader :line
    attr_reader :size
    attr_reader :position
    attr_reader :vertical

    def self.parse(data)
      Setting.new(data)
    end

    def initialize(data)
      @data = data
      self.vertical = to_h['vertical']
      self.line = to_h['line']
      self.position = to_h['position']
      self.size = to_h['size']
      self.align = to_h['align']
    end

    def vertical=(value)
      raise 'Invalid vertical value.' if invalid_vertical?(value)
      @vertical = value
    end

    def line=(value)
      @line = value
    end

    def position=(value)
      raise 'Invalid position value.' if invalid_percentage?(value)
      @position = value
    end

    def size=(value)
      raise 'Invalid size value.' if invalid_percentage?(value)
      @size = value
    end

    def align=(value)
      raise 'Invalid align value' if invalid_align?(value)
      @align = value
    end

    def to_h
      YAML.load(@data.gsub(/:[\s]{0,}/, ': '))
    end

    private

    def invalid_vertical?(value)
      !VALID_VERTICAL_VALUES.include?(value)
    end

    def invalid_align?(value)
      !VALID_ALIGN_VALUES.include?(value)
    end

    def invalid_percentage?(value)
      value.to_s[-1] != '%' ||
        !PERCENTAGE_VALUES.include?(value.to_s.gsub('%', ''))
    end
  end
end
