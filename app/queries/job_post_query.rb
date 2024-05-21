class JobPostQuery
  include Pagy::Backend
  attr_reader :options

  alias_method :build_pagy, :pagy

  def initialize(options = {})
    @options = options.to_h.symbolize_keys
    setup_defaults
  end

  def query_and_paginate
    if @options.empty?
      @records = Businesses::JobPost.open
    else
      @records = Businesses::JobPost.open.includes(:role_level, :role_type)
      apply_filters
    end
    @pagy, @records = build_pagy(@records, items: items_per_page)
  end

  private

  def apply_filters
    apply_role_level_filters if @role_level.present?
    @records = @records.with_role_locations(@role_location) if @role_location.present? && Businesses::JobPost.valid_role_locations?(@role_location)
    @records = @records.with_role_type(@role_type) if @role_type.present?
    filter_by_payment_terms if @role_type.present?
  end

  def apply_role_level_filters
    level_conditions = @role_level.reject(&:blank?).map do |level|
      "role_levels.#{level} = true"
    end.join(' OR ')
    @records = @records.joins(:role_level).where(level_conditions) if level_conditions.present?
  end

def filter_by_payment_terms
  Rails.logger.debug "Current records: #{@records.inspect}"
  if @fixed_fee[:min].present? || @fixed_fee[:max].present?
    @records = @records.where("fixed_fee >= ?", @fixed_fee[:min]) if @fixed_fee[:min].present?
    @records = @records.where("fixed_fee <= ?", @fixed_fee[:max]) if @fixed_fee[:max].present?
  end
  if @salary_range[:min].present? || @salary_range[:max].present?
    @records = @records.where("salary_range_min >= ?", @salary_range[:min]) if @salary_range[:min].present?
    @records = @records.where("salary_range_max <= ?", @salary_range[:max]) if @salary_range[:max].present?
  end
  Rails.logger.debug "Filtered records: #{@records.inspect}"
end

  def setup_defaults
    @role_level = options.fetch(:role_level, nil)
    @role_type = options.fetch(:role_type, nil)
    @role_location = options.fetch(:role_location, nil)
    
    fixed_fee_options = options.slice(:fixed_fee_min, :fixed_fee_max)
    @fixed_fee = fixed_fee_options.any? ? { min: fixed_fee_options[:fixed_fee_min], max: fixed_fee_options[:fixed_fee_max] } : {}

    salary_range_options = options.slice(:salary_range_min, :salary_range_max)
    @salary_range = salary_range_options.any? ? { min: salary_range_options[:salary_range_min], max: salary_range_options[:salary_range_max] } : {}

    @items_per_page = options.fetch(:items_per_page, Pagy::DEFAULT[:items])
    Rails.logger.debug "Initialized query with options: #{@fixed_fee}, #{@salary_range}"
  end

  def items_per_page
    @items_per_page
  end

  def params
    options
  end
end
