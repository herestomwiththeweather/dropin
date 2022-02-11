class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :identifier
      t.string :secret
      t.string :company

      t.timestamps
    end
  end
end
