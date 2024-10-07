class CreateAdvisors < ActiveRecord::Migration[7.1]
  def change
    create_table :advisors do |t|
      t.string :name
      t.integer :phone
      t.string :email
      t.string :website
      t.string :address
      t.string :city
      t.text :bio
      t.string :certifications
      t.string :specializations
      t.integer :experience_years
      t.string :education
      t.string :availability

      t.timestamps
    end
  end
end
