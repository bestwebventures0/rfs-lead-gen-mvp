class AddPricingToAdvisors < ActiveRecord::Migration[7.1]
  def change
    add_column :advisors, :pricing, :string
  end
end
