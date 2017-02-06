# WebVTT

Parse WebVTT files.

### Sample usage

```ruby
file =
  "WEBVTT\n" \
  "00:01.000 --> 00:04.000" \
  "\nNever drink liquid nitrogen.\nIt is not safe." \
  "\n\n" \
  "00:05.000 --> 00:10.000" \
  "\nBut it is safe to drink water." \
  "\n\n" \
  "00:11.000 --> 00:15.000" \
  "\nI love Coke ZERO!" \
  "\n\n" \
  "00:16.000 --> 00:25.000" \
  "\nWell. What should we drink then?"

webvtt = WebVTT.read(file)
webvtt.cues.each do |cue|
  puts cue.to_s
end

```