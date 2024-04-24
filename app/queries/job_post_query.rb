class JobPostQuery
  include Pagy::Backend

  attr_reader :options

  def initialize(options = {})
    @options = options
    @role_level = options.delete(:role_level)
    @role_location = options.delete(:role_location)
    @role_type = options.delete(:role_type)
    @fixed_fee = options.delete(:fixed_fee)
    @salary_range_min = options.delete(:salary_range_min)
    @salary_range_max = options.delete(:salary_range_max)
  end

  def records
    query_and_paginate.last
  end

  def pagy_and_records
    apply_filters
    @pagy, @records = pagy(@_records, items: items_per_page)
    return [@pagy, @records]
  end

  private

  def query_and_paginate
    @_records = Businesses::JobPost.includes(:role_level, :role_type).open
    apply_filters
    @_records
  end

  def apply_filters
    filter_by_role_level
    filter_by_role_location
    filter_by_role_type
  end

  def filter_by_role_level
    @_records = @_records.joins(:role_level).where(role_levels: { @role_level.downcase.to_sym => true }) if @role_level.present?
  end

  def filter_by_role_location
    @_records = @_records.where(role_location: @role_location) if @role_location.present?
  end

  def filter_by_role_type
    return unless @role_type.present?

    case @role_type
    when 'full_time_employment'
        @_records = @_records.where('salary_range_min >= ? AND salary_range_max <= ?', @salary_range_min, @salary_range_max)
    when 'part_time_contract', 'full_time_contract'
        @_records = @_records.where('fixed_fee >= ?', @fixed_fee)
    end
  end

  def items_per_page
    @options[:items_per_page] || Pagy::DEFAULT[:items]
  end
end
