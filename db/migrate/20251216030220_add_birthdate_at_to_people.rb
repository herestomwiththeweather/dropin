class AddBirthdateAtToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :birthdate_at, :datetime
  end
end
