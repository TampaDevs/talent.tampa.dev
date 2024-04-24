class AddIndexForSearchableFieldsInJobPosts < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      ALTER TABLE job_posts
        ADD COLUMN textsearchable_index_col tsvector
          GENERATED ALWAYS AS (to_tsvector('simple', coalesce(title, '') || ' ' || coalesce(description, ''))) STORED;
    SQL

    add_index :job_posts, :textsearchable_index_col, using: :gin, name: :textsearchable_index_job_posts
  end

  def down
    remove_index :job_posts, name: :textsearchable_index_job_posts
    remove_column :job_posts, :textsearchable_index_col
  end
end
