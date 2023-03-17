class AddClientIdToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :client_id, :bigint
  end
end
