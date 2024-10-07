class Meeting < ApplicationRecord
  belongs_to :match

  validates_presence_of :day, :when, :how
  validates_uniqueness_of :match

  def get_date
    case self.when
    when "Earliest Available"
      return "Earliest Available"
    when "In 3 Days"
      return (created_at + 3.days).strftime("%d-%m-%Y")
    when "Next Week"
      return (created_at + 7.days).strftime("%d-%m-%Y")
    when "Not Sure"
      return "Not Sure"
    end
  end

  def self.get_meeting_by_advisor_and_user(user, advisor)
    self.where(match: Match.where(user: user, advisor: advisor)).uniq.first
  end

  def self.ransackable_associations(auth_object = nil)
    ["match"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "day", "how", "id", "id_value", "match_id", "updated_at", "when", "note", "done"]
  end
end
