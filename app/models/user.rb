# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  first_name             :string
#  last_name              :string
#  phone                  :integer
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  
  has_one :questionnaire, dependent: :destroy

  has_many :matches, dependent: :destroy
  has_many :advisors, -> { distinct }, through: :matches #, uniq: true # select: "DISTICT advisors.*"
  has_many :meetings, through: :matches

  cattr_accessor :form_steps do
    %w(your_details confirm_your_email)
  end
  attr_accessor :form_step

  with_options if: -> { required_for_step?(:your_details) } do |step|
    step.validates :first_name, presence: true
    step.validates :last_name, presence: true
    step.validates :phone, presence: true, uniqueness: true, length: { minimum: 10, maximum: 10 }, numericality: true
  end

  def required_for_step?(step)
    # All fields are required if no form step is present
    return true if form_step.nil?
  
    # All fields from previous steps are required if the
    # step parameter appears before or we are on the current step
    return true if self.form_steps.index(step.to_s) <= self.form_steps.index(form_step)
  end
  
  OTP_LENGTH = 6 
  def send_confirmation_instructions
    token = SecureRandom.random_number(10**OTP_LENGTH).to_s.rjust(OTP_LENGTH, "0")
    self.confirmation_token = token
    self.confirmation_sent_at = Time.now.utc
    save(validate: false)
    ConfirmationsMailer.confirmation_instructions(self, self.confirmation_token).deliver_later
  end

  def password_required?
    return false if new_record?
    super
  end

  def full_name
    (self.first_name.capitalize + ' ' + self.last_name.capitalize)
  end

  # For ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "encrypted_password", "id", "id_value", "remember_created_at", "reset_password_sent_at", "reset_password_token", "updated_at", "confirmation_token", "unconfirmed_email", "first_name", "last_name", "phone"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["questionnaire"]
  end

  protected

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
