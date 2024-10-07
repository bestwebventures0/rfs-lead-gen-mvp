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
class Advisor < ApplicationRecord
    has_many :matches, dependent: :destroy
    has_many :users, -> { distinct }, through: :matches
    has_one_attached :avatar do |attachable|
        attachable.variant :thumb, resize_to_limit: [180, 180]
    end
    has_many :meetings, through: :matches

    validates_presence_of :name, :phone, :email, :website, :address, :city, :certifications, :specializations, :experience_years, :education, :availability, :bio, :licenses, :company_name, :client_types, :pricing

    validates_numericality_of :phone, :experience_years, only_integer: true
    validates_length_of :phone, minimum: 10, maximum: 10
    validates_length_of :experience_years, minimum: 1, maximum: 2

    validate :acceptable_image

    def acceptable_image
        return unless avatar.attached?
        
        unless avatar.blob.byte_size <= 512.kilobyte
          errors.add(:avatar, "is too big")
        end
        
        acceptable_types = ["image/jpg", "image/jpeg", "image/png"]
        unless acceptable_types.include?(avatar.content_type)
          errors.add(:avatar, "must be a JPEG, JPG or PNG")
        end
    end

    # for activeamdin
    def self.ransackable_associations(auth_object = nil)
        ["matches", "users"]
    end

    def self.ransackable_attributes(auth_object = nil)
        ["address", "availability", "bio", "certifications", "city", "created_at", "education", "email", "experience_years", "id", "id_value", "name", "phone", "specializations", "updated_at", "website", "avatar_attachment_id_eq", "avatar_blob_id_eq", "licenses", "company_name", "client_types", "meetings_id_eq", "pricing"]
    end
end
