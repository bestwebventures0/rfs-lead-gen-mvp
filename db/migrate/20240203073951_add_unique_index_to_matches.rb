class AddUniqueIndexToMatches < ActiveRecord::Migration[7.1]
  def change
    add_index(:matches, [:advisor_id, :user_id], unique: true)
  end
end
