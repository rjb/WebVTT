# Webvtt

Parse WebVTT files.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'webvtt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install webvtt

## Usage

```ruby
# speech.vtt
# WEBVTT
#
# REGION
# id:1
# width:40%
# lines:3
# regionanchor:0%,100%
# viewportanchor:10%,90%
# scroll:up
#
# STYLE
# ::cue {
#   background-image: linear-gradient(to bottom, dimgray, lightgray);
#   color: papayawhip;
# }
# 
# 00:00.000 --> 00:04.000
# Thank you. Thank you. Thank you.
# This is fantastic.
# 
# 00:05.000 --> 009.000
# I never made it to college.
# I didn't have enough money 
# 
# 00:09.000 --> 00:12.000
# and I decided I was going to be
# a writer anyway.
# 
# 00:13.000 --> 00:16.000
# And the reason I was going to go
# to college was all those girls.
# 
# 00:17.000 --> 00:19.000
# So it's a good thing I didn't go.

webvtt = webvtt = WebVTT::File.read('speech.vtt')

# Cues
webvtt.cues.each do |cue|
  puts "Start: #{cue.start}"
  puts "Stop: #{cue.stop}"
  puts "Text: #{cue.text}"
end

# Region
puts "Id: #{webvtt.region.id}"
puts "Width: #{webvtt.region.width}"
puts "Lines: #{webvtt.region.lines}"
puts "Region anchor point: #{webvtt.region.region_anchor}"
puts "Region viewport anchor point: #{webvtt.region.viewport_anchor}"
puts "Scroll: #{webvtt.region.scroll}"

# Comments / Notes
webvtt.comments.each do |comment|
  puts comment
end

# Styling
puts webvtt.style
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rjb/webvtt. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

