class CreateMeetings < ActiveRecord::Migration[7.1]
  def change
    create_table :meetings do |t|
      t.references :match, null: false, foreign_key: {on_delete: :cascade}
      t.string :day
      t.string :when
      t.string :how

      t.timestamps
    end
  end
end
