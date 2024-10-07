class CreateQuestionnaires < ActiveRecord::Migration[7.1]
  def change
    create_table :questionnaires do |t|
      t.integer :age
      t.integer :pincode
      t.string :annual_income_in_lacs
      t.string :cash_assets_in_lacs
      t.string :real_estate_assets_in_lacs
      t.string :investments_in_lacs
      t.string :retirement_investments_in_lacs
      t.string :stock_investments_in_lacs
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :questionnaires, :pincode
    add_index :questionnaires, :age
  end
end
