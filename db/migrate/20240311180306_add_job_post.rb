class AddJobPost < ActiveRecord::Migration[7.0]
  def change
    create_table :job_posts do |t|
      t.references :business, null: false, foreign_key: true
      t.integer :status, default: 1, null: false
      t.integer :role_location, null: false
      t.integer :salary_range_min
      t.integer :salary_range_max
      t.integer :fixed_fee
      t.string :description, null: false
      t.string :city, null: false

      t.timestamps
    end

    add_index :job_posts, :status
    add_index :job_posts, :role_location
    add_index :job_posts, :city
  end
end
