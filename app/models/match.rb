# == Schema Information
#
# Table name: matches
#
#  id         :integer          not null, primary key
#  advisor_id :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Match < ApplicationRecord
  belongs_to :advisor
  belongs_to :user
  has_one :meeting

  validates_uniqueness_of :advisor_id, scope: :user_id

  # for activeadmin
  def self.ransackable_associations(auth_object = nil)
    ["advisor", "user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["advisor_id", "created_at", "id", "id_value", "updated_at", "user_id", "meeting_id_eq"]
  end

  def to_s
    self.advisor.name + ' - ' + self.user.full_name
  end
end
