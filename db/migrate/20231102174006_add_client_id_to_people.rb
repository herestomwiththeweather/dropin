class AddClientIdToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :client_id, :bigint
  end
end
