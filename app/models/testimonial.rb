# frozen_string_literal: true

Testimonial = Struct.new(:image, :name, :testimonial, :title, :url, keyword_init: true) do
  def self.all
    # TODO: New testimonials
    Rails.configuration.testimonials.map { |h| new(h) }
  end
end
