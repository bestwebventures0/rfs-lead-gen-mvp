class AddColumnsToAdvisor < ActiveRecord::Migration[7.1]
  def change
    add_column :advisors, :licenses, :string
    add_column :advisors, :company_name, :string
    add_column :advisors, :client_types, :string
  end
end
