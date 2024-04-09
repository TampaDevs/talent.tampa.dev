class RoleLevel < ApplicationRecord
  TYPES = %i[junior mid senior principal c_level].freeze

  belongs_to :developer, optional: true
  belongs_to :job_post, class_name: 'Businesses::JobPost', optional: true

  def missing_fields?
    TYPES.none? { |t| send(t) }
  end

  def level=(level)
    return unless TYPES.include?(level.to_sym)

    TYPES.each do |type|
      self.send("#{type}=", type.to_s == level)
    end
  end

  # Getter method for 'level' to identify which level is currently true
  def level
    TYPES.find { |type| send(type) }&.to_s
  end
end
