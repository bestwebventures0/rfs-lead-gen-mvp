class AddDoneToMeetings < ActiveRecord::Migration[7.1]
  def change
    add_column :meetings, :done, :boolean
    add_index :meetings, :done
  end
end
