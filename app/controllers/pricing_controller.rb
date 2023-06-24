class PricingController < ApplicationController
  def show
    @stats = Pricing::Stats.new
    @testimonials = Testimonial.all
    Analytics::Event.pricing_viewed(current_user, cookies)
  end
end
