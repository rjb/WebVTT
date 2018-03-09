# Webvtt

Parse WebVTT files.

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

webvtt = WebVTT::File.read('speech.vtt')

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