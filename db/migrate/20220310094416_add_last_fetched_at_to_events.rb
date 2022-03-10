class AddLastFetchedAtToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :last_fetched_at, :datetime
  end
end
