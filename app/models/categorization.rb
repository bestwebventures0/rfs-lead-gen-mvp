# == Schema Information
#
# Table name: categorizations
#
#  id               :integer          not null, primary key
#  category_id      :integer          not null
#  questionnaire_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Categorization < ApplicationRecord
  belongs_to :category
  belongs_to :questionnaire

  # For active_admin
  def self.ransackable_attributes(auth_object = nil)
    ["category_id", "created_at", "id", "id_value", "questionnaire_id", "updated_at"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["category", "questionnaire"]
  end
end
