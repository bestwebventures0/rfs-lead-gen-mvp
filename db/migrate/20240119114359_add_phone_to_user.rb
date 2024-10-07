class AddPhoneToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :phone, :integer
    add_index :users, :phone, unique: true
  end
end
