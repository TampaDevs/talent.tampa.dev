class UpdateJobApplicationStatuses < ActiveRecord::Migration[7.0]
  def up
    # Assuming your model and table name are correctly set up as mentioned
    Developers::JobApplication.where(status: 0).update_all(status: :new_status)
    Developers::JobApplication.where(status: 1).update_all(status: :considered)
    Developers::JobApplication.where(status: 2).update_all(status: :other)
  end

  def down
    # Reverting changes in case the migration needs to be rolled back
    Developers::JobApplication.where(status: :new_status).update_all(status: 0)
    Developers::JobApplication.where(status: :considered).update_all(status: 1)
    Developers::JobApplication.where(status: :other).update_all(status: 2)
  end
end
