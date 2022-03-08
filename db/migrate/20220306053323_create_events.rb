class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.integer :identifier
      t.datetime :start_at

      t.timestamps
    end
  end
end
