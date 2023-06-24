Rails.application.config.analytics_key = ENV["SEGMENT_WRITE_KEY"]

SegmentClient = Segment::Analytics.new({
  write_key: Rails.application.config.analytics_key,
  on_error: proc { |status, msg| print msg }
})
