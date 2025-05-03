class AddFontsizeToClients < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :fontsize, :decimal, precision: 3, scale: 2, default: 1
  end
end
