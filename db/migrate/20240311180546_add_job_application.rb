class AddJobApplication < ActiveRecord::Migration[7.0]
  def change
    create_table :job_applications do |t|
      t.references :job_post, null: false, foreign_key: {to_table: :job_posts}, index: true
      t.references :developer, null: false, foreign_key: {to_table: :developers}, index: true
      t.integer :status, default: 0, null: false

      t.timestamps
    end
    
    add_index :job_applications, :status
  end
end
