class RoleType < ApplicationRecord
  TYPES = %i[part_time_contract full_time_contract full_time_employment].freeze

  belongs_to :developer, optional: true
  belongs_to :job_post, class_name: "Businesses::JobPost", optional: true

  def missing_fields?
    TYPES.none? { |t| send(t) }
  end

  def humanize
    TYPES.select { |t| send(t) }.map { |t| t.to_s.humanize }.to_sentence
  end

  def only_full_time_employment?
    full_time_employment &&
      !part_time_contract? &&
      !full_time_contract?
  end
end
