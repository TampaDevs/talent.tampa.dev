class JobPostQuery
  include Pagy::Backend

  alias_method :build_pagy, :pagy

  attr_reader :options

  def initialize(options = {})
    @options = options
    @role_level = options.delete(:role_level)
    @role_location = options.delete(:role_location)
    @role_type = options.delete(:role_type)
    @fixed_fee = options.delete(:fixed_fee)
    @pay_range_min = options.delete(:pay_range_min)
    @pay_range_max = options.delete(:pay_range_max)
    @user = options.delete(:user)
  end

  def filters
    @filters = {search_query:, role_level:, role_location:, role_type:, pay_range_min:, pay_range_max:}
  end

  def pagy
    @pagy ||= query_and_paginate.first
  end

  def records
    @records ||= query_and_paginate.last
  end

  def search_query
    @search_query.to_s.strip
  end

  private

  def query_and_paginate
    @_records = Businesses::JobPost.includes(:role_level, :role_type).open
    apply_filters
    @pagy, @records = build_pagy(@_records, items: items_per_page)
  end

  def sort_records
    @_records.merge!(Businesses::JobPost.newest_first)
  end

  def items_per_page
    @items_per_page || Pagy::DEFAULT[:items]
  end

  def apply_filters
    filter_by_role_level
    filter_by_role_type
    filter_by_role_location
    filter_by_pay_range
  end

  def filter_by_role_level
    @_records = @_records.joins(:role_level).where(role_levels: { @role_level.downcase.to_sym => true }) if @role_level.present?
  end

  def filter_by_role_location
    @_records = @_records.where(role_location: @role_location) if @role_location.present?
  end

  def filter_by_pay_range
    return unless @role_type.present?

    case @role_type
    when 'full_time_employment'
        @_records = @_records.where('salary_range_min >= ? AND salary_range_max <= ?', @pay_range_min, @pay_range_max)
    when 'part_time_contract', 'full_time_contract'
        @_records = @_records.where('fixed_fee >= ? AND fixed_fee <= ?', @pay_range_min, @pay_range_max)
    end
  end

  def items_per_page
    @options[:items_per_page] || Pagy::DEFAULT[:items]
  end

  # Needed for #pagy (aliased to #build_pagy) helper.
  def params
    options
  end
end
