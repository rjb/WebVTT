module WebVTT
  class Region
    VALID_SCROLL_VALUES = ['none', 'up']

    attr_reader :data
    attr_reader :id
    attr_reader :width
    attr_reader :lines
    attr_reader :scroll
    attr_reader :region_anchor
    attr_reader :viewport_anchor

    def self.parse(data)
      region = Region.new(data)
      region.parse
      region
    end

    def initialize(data)
      @data = data
    end

    def parse
      if data.match(/REGION\s{0,}[\r\n]{1}/).nil?
        raise 'Invalid definition block.'
      end

      settings = parse_settings

      @id = settings['id'] || ''
      @width = settings['width'] || ''
      @lines = settings['lines'] || ''
      @scroll = settings['scroll'] || ''
      @region_anchor = settings['regionanchor'] || ''
      @viewport_anchor = settings['viewportanchor'] || ''

      validate
    end

    private

    def parse_settings
      data.gsub(/REGION\s+/, '').split.each_with_object({}) do |item, settings|
        key, val = item.split(':')

        if key.empty? || val.nil?
          raise 'Invalid region setting.'
        end

        settings[key] = val
      end
    end

    def validate
      validate_id
      validate_width unless @width.empty?
      validate_lines unless @lines.empty?
      validate_scroll unless @scroll.empty?
      validate_region_anchor unless @region_anchor.empty?
      validate_viewport_anchor unless @viewport_anchor.empty?
    end

    def validate_id
      raise ArgumentError, 'Id must not contain the substring \'-->\'.' if @id.match(/-->/)
    end

    def validate_width
      raise ArgumentError, 'Width must be a valid percentage.' unless valid_percentage?(@width)
    end

    def validate_lines
      raise ArgumentError, 'Lines must be one or more digits.' unless @lines.match(/^[0-9]+$/)
    end

    def validate_scroll
      unless VALID_SCROLL_VALUES.include?(@scroll.downcase)
        raise ArgumentError, 'Scroll must be an empty string, \'None\', or \'Up\'.'
      end
    end

    def validate_region_anchor
      coordinates = @region_anchor.split(',')
      unless coordinates.all? { |item| valid_percentage?(item) }
        raise ArgumentError, 'Region anchor must be two valid percentges.'
      end
    end

    def validate_viewport_anchor
      coordinates = @viewport_anchor.split(',')
      unless coordinates.all? { |item| valid_percentage?(item) }
        raise ArgumentError, 'Viewport anchor must be two valid percentges.'
      end
    end

    def valid_percentage?(value)
      percentage = value.to_f
      value[-1] == '%' && (0..100).include?(percentage)
    end
  end
end
