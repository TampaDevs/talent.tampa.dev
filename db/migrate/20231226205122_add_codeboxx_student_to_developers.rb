class AddCodeboxxStudentToDevelopers < ActiveRecord::Migration[7.0]
  def change
    add_column :developers, :codeboxx_student, :boolean
  end
end
