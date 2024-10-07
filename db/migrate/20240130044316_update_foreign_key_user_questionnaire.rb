class UpdateForeignKeyUserQuestionnaire < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :questionnaires, :users
    remove_foreign_key :categorizations, :categories
    remove_foreign_key :categorizations, :questionnaires
    add_foreign_key :questionnaires, :users, on_delete: :cascade
    add_foreign_key :categorizations, :categories, on_delete: :cascade
    add_foreign_key :categorizations, :questionnaires, on_delete: :cascade
  end
end
