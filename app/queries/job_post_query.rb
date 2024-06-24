class JobPostQuery
  attr_reader :options

  def initialize(options = {})
    @options = options.to_h.symbolize_keys
    Rails.logger.debug "Query options: #{@options}"
    setup_defaults
    Rails.logger.debug "Setup defaults: #{@role_level}, #{@role_type}, #{@role_location}, #{@reimbursement_min}, #{@reimbursement_max}"
  end

  def query
    @records = Businesses::JobPost.open.includes(:role_level, :role_type)
    apply_filters unless @options.empty?
    @records || Businesses::JobPost.none
  end

  private

  def apply_filters
    apply_role_level_filters if @role_level.present?
    apply_role_type_filters if @role_type.present?
    apply_role_location_filters if @role_location.present?
    apply_reimbursement_filters if @reimbursement_min.present? || @reimbursement_max.present?
  end

  def apply_role_level_filters
    level_conditions = @role_level.reject(&:blank?).map do |level|
      "role_levels.#{level} = true"
    end.join(" OR ")
    @records = @records.joins(:role_level).where(level_conditions) if level_conditions.present?
  end

  def apply_role_type_filters
    role_type_conditions = @role_type.reject(&:blank?).map do |type|
      "role_types.#{type.parameterize(separator: "_")} = true"
    end.join(" OR ")
    @records = @records.joins(:role_type).where(role_type_conditions) if role_type_conditions.present?
  end

  def apply_role_location_filters
    @records = @records.with_role_locations(@role_location) if Businesses::JobPost.valid_role_locations?(@role_location)
  end

  def apply_reimbursement_filters
    reimbursement_min = @reimbursement_min.presence&.to_i
    reimbursement_max = @reimbursement_max.presence&.to_i

    if reimbursement_min && reimbursement_max
      @records = @records.filter_by_payment_terms(min: reimbursement_min, max: reimbursement_max)
    elsif reimbursement_min
      @records = @records.filter_by_payment_terms(min: reimbursement_min)
    elsif reimbursement_max
      @records = @records.filter_by_payment_terms(max: reimbursement_max)
    end
  end

  def setup_defaults
    @role_level = options.fetch(:role_level, nil)
    @role_type = options.fetch(:role_type, nil)
    @role_location = options.fetch(:role_location, nil)
    @reimbursement_min = options.fetch(:reimbursement_min, "")
    @reimbursement_max = options.fetch(:reimbursement_max, "")
  end

  def params
    options
  end
end
