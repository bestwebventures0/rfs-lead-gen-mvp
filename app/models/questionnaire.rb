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
class Questionnaire < ApplicationRecord
  belongs_to :user, optional: true, dependent: :destroy
  # Categories seed = %w(
    # Retirement\ Planning 
    # Post\ Retirement\ Finances
    # Property\ Investment 
    # Tax\ Planning 
    # Family\ Financial\ Security
    # Goal\ Planning 
    # Wealth\ Inheritance 
    # Investment\ Portfolio\ And\ Wealth\ Building
    # Specialized\ Financial\ Advice
  # )
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations

  cattr_accessor :form_steps do
    %w(
      how_old_are_you 
      where_do_you_live 
      what_do_you_need_help_with 
      what_is_your_annual_household_income 
      how_much_cash_assets_do_you_own 
      how_much_real_estate_assets_do_you_own 
      how_much_investments_do_you_own 
      how_much_retirement_investments_do_you_own 
      how_much_stock_investments_do_you_own 
      your_details 
      confirm_your_email
      )
  end
  attr_accessor :form_step

  with_options if: -> { required_for_step?(:how_old_are_you) } do |step|
    step.validates :age, presence: true, length: { minimum: 2, maximum: 2 }, numericality: { less_than_or_equal_to: 90, greater_than_or_equal_to: 18 }
  end

  with_options if: -> { required_for_step?(:where_do_you_live) } do |step|
    step.validates :pincode, numericality: true
    step.validates :pincode, presence: true, length: { minimum: 6, maximum: 6 }
  end

  validates_presence_of :categories, if: -> { required_for_step?('what_do_you_need_help_with') } #TODO: validation not working

  with_options if: -> { required_for_step?(:what_is_your_annual_household_income) } do |step|
    step.validates :annual_income_in_lacs, presence: true
  end

  with_options if: -> { required_for_step?(:how_much_cash_assets_do_you_own) } do |step|
    step.validates :cash_assets_in_lacs, presence: true
  end

  with_options if: -> { required_for_step?(:how_much_real_estate_assets_do_you_own) } do |step|
    step.validates :real_estate_assets_in_lacs, presence: true
  end

  with_options if: -> { required_for_step?(:how_much_investments_do_you_own) } do |step|
    step.validates :investments_in_lacs, presence: true
  end

  with_options if: -> { required_for_step?(:how_much_retirement_investments_do_you_own) } do |step|
    step.validates :retirement_investments_in_lacs, presence: true
  end

  with_options if: -> { required_for_step?(:how_much_stock_investments_do_you_own) } do |step|
    step.validates :stock_investments_in_lacs, presence: true
  end

  def required_for_step?(step)
    # All fields are required if no form step is present
    return true if form_step.nil?
  
    # All fields from previous steps are required if the
    # step parameter appears before or we are on the current step
    return true if self.form_steps.index(step.to_s) <= self.form_steps.index(form_step)
  end

  # For ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["age", "annual_income_in_lacs", "cash_assets_in_lacs", "created_at", "id", "id_value", "investments_in_lacs", "pincode", "real_estate_assets_in_lacs", "retirement_investments_in_lacs", "stock_investments_in_lacs", "updated_at", "user_id", "category_ids"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["categories", "categorizations", "user"]
  end
end
