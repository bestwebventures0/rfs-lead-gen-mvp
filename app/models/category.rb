# == Schema Information
#
# Table name: categories
#
#  id          :integer          not null, primary key
#  title       :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Category < ApplicationRecord
  has_many :categorizations, dependent: :destroy
  has_many :questionnaires, through: :categorizations
  validates_presence_of :title

  # For active_admin
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "title", "updated_at"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["categorizations", "questionnaires"]
  end
end
