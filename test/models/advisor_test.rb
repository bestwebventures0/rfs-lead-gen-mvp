# == Schema Information
#
# Table name: advisors
#
#  id               :integer          not null, primary key
#  name             :string
#  phone            :integer
#  email            :string
#  website          :string
#  address          :string
#  city             :string
#  bio              :text
#  certifications   :string
#  specializations  :string
#  experience_years :integer
#  education        :string
#  availability     :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  licenses         :string
#  company_name     :string
#  client_types     :string
#
require "test_helper"

class AdvisorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
