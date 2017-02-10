# WebVTT

Parse WebVTT files.

### Usage

```ruby

# speech.vtt
# WEBVTT
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

puts webvtt.style

webvtt.cues.each do |cue|
  puts "Start: " + cue.start
  puts "Stop: " + cue.stop
  puts "Text: " + cue
end
```