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
        raise TypeError, 'Not a valid region.'
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

        raise ArgumentError, 'Invalid region setting.' if key.empty?

        integer = Integer(val) rescue nil

        settings[key] = integer || val
      end
    end

    def validate
      validate_id
      validate_width
      validate_lines
      validate_scroll
      validate_region_anchor
      validate_viewport_anchor
    end

    def validate_id
      if "#{@id}".match(/-->/)
        raise ArgumentError, 'Id must not contain the substring \'-->\'.'
      end
    end

    def validate_width
      if !@width.to_s.empty? && !valid_percentage?(@width)
        raise ArgumentError, 'Width must be a valid percentage.'
      end
    end

    def validate_lines
      if !@lines.to_s.empty? && !@lines.to_s.match(/^[0-9]+$/)
        raise ArgumentError, 'Lines must be one or more digits.'
      end
    end

    def validate_scroll
      if !@scroll.empty? && !VALID_SCROLL_VALUES.include?(@scroll.downcase)
        raise ArgumentError, 'Scroll must be an empty string, \'None\', or \'Up\'.'
      end
    end

    def validate_region_anchor
      coordinates = @region_anchor.split(',')
      if !@region_anchor.empty? && !coordinates.all? { |item| valid_percentage?(item) }
        raise ArgumentError, 'Region anchor must be two valid percentges.'
      end
    end

    def validate_viewport_anchor
      coordinates = @viewport_anchor.split(',')
      if !@viewport_anchor.empty? && !coordinates.all? { |item| valid_percentage?(item) }
        raise ArgumentError, 'Viewport anchor must be two valid percentges.'
      end
    end

    def valid_percentage?(value)
      percentage = value.to_f
      value[-1] == '%' && (0..100).include?(percentage)
    end
  end
end
