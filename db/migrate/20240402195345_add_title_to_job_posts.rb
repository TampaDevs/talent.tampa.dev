class AddTitleToJobPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :job_posts, :title, :string
  end
end
