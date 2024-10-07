# == Schema Information
#
# Table name: questionnaires
#
#  id                             :integer          not null, primary key
#  age                            :integer
#  pincode                        :integer
#  annual_income_in_lacs          :string
#  cash_assets_in_lacs            :string
#  real_estate_assets_in_lacs     :string
#  investments_in_lacs            :string
#  retirement_investments_in_lacs :string
#  stock_investments_in_lacs      :string
#  user_id                        :integer          not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
require "test_helper"

class QuestionnaireTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
