require 'yaml'

module WebVTT
  class Region
    attr_reader :data
    attr_reader :id
    attr_reader :width
    attr_reader :lines
    attr_reader :scroll
    attr_reader :region_anchor
    attr_reader :viewport_anchor

    def self.parse(data)
      Region.new(data)
    end

    def initialize(data)
      @data = data
      @id = to_h["id"] || nil
      @width = to_h["width"] || nil
      @lines = to_h["lines"] || nil
      @scroll = to_h["scroll"] || nil
      @region_anchor = to_h["regionanchor"] || nil
      @viewport_anchor = to_h["viewportanchor"] || nil
    end

    def to_h
      content = @data.gsub(/REGION[\s]{0,}/, '').gsub(/:[\s]{0,}/, ': ')
      YAML.load(content) || {}
    end
  end
end
