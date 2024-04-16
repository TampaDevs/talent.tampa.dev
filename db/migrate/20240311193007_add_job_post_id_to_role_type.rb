class AddJobPostIdToRoleType < ActiveRecord::Migration[7.0]
  def change
    add_reference :role_types, :job_post, null: true, foreign_key: true
  end
end
