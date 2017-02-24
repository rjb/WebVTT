module WebVTT
  class Setting
    VALID_VERTICAL_VALUES = %w(rl lr).freeze
    VALID_ALIGN_VALUES = %w(start center end left right).freeze
    VALID_PERCENTAGE = /((^100%$)|(^\d{1,2}%$))|(^\d{1,2}\.\d+%$)/
    VALID_POSITION = /((^100%$)|(^\d{1,2}%$))|((^100%)|(^\d{1,2}%)\,(line-left|center|line-right)$)/
    VALID_LINE = /(^\-\d+$)|((^100%$)|(^\d{1,2}%$))|((^\-{0,1}\d+)|((^100%)|(^\d{1,2}%))\,(start|center|end)$)/

    attr_reader :data
    attr_reader :line
    attr_reader :size
    attr_reader :align
    attr_reader :position
    attr_reader :vertical

    def self.parse(data)
      setting = Setting.new(data)
      setting.parse
      setting
    end

    def initialize(data)
      @data = data
    end
 
    def parse
      settings = parse_data

      @line = settings['line'] || ''
      @size = settings['size'] || ''
      @align = settings['align'] || ''
      @position = settings['position'] || ''
      @vertical = settings['vertical'] || ''

      validate
    end

    def to_s
      @data
    end

    private

    def parse_data
      @data.split.each_with_object({}) do |item, settings|
        key, val = item.split(':')

        if key.empty? || val.nil?
          raise 'Invalid setting.'
        end

        integer = Integer(val) rescue nil

        settings[key] = integer || val
      end
    end

    def validate
      validate_line
      validate_size
      validate_align
      validate_position
      validate_vertical
    end

    def validate_line
      raise ArgumentError, 'Invalid line.' unless line_valid?
    end

    def validate_size
      raise ArgumentError, 'Size must be percentage between 0 and 100.' unless size_valid?
    end

    def validate_align
      raise ArgumentError, "Align must be #{VALID_ALIGN_VALUES.join(', ')}" unless align_valid?
    end

    def validate_position
      raise ArgumentError, 'Invalid position.' unless position_valid?
    end

    def validate_vertical
      raise ArgumentError, "Region must be #{VALID_VERTICAL_VALUES.join(' or ')}" unless vertical_valid?
    end

    def line_valid?
      @line.empty? || @line.match(VALID_LINE)
    end

    def size_valid?
      @size.empty? || @size.match(VALID_PERCENTAGE)
    end

    def align_valid?
      @align.empty? || VALID_ALIGN_VALUES.include?(@align)
    end

    def position_valid?
      @position.empty? || @position.match(VALID_POSITION)
    end

    def vertical_valid?
      @vertical.empty? || VALID_VERTICAL_VALUES.include?(@vertical)
    end
  end
end
