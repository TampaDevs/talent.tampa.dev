class AddCitiesToAnalyticsSearchQueries < ActiveRecord::Migration[7.0]
  def change
    add_column :analytics_search_queries, :cities, :string
  end
end
