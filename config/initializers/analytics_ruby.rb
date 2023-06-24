Rails.application.config.analytics_key = ENV["SEGMENT_WRITE_KEY"]

class SegmentAnalyticsStub
  def initialize(*); end

  def track(*args)
    Rails.logger.debug "Segment::Analytics.track called with args: #{args.inspect}"
  end

  def identify(*args)
    Rails.logger.debug "Segment::Analytics.identify called with args: #{args.inspect}"
  end
end

if Rails.application.config.analytics_key.blank?
  Rails.logger.warn "Segment analytics key not found."
  SegmentClient = SegmentAnalyticsStub.new
else
  SegmentClient = Segment::Analytics.new({
    write_key: Rails.application.config.analytics_key,
    on_error: proc { |status, msg| print msg }
  })
end
