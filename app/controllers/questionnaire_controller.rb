class QuestionnaireController < ApplicationController
  layout "questionnaire"

  include Wicked::Wizard
  steps *Questionnaire.form_steps
  before_action :set_session_and_cache, only: [:show]
  before_action :redirect_to_1st_step, only: [:show]
  before_action :print_session, only: [:show, :update]

  OTP_EXPIRATION_TIME = 5.minutes.ago

  def show
    # called method 'set_session_and_cache' using before_action
    # called method 'redirect_to_1st_step' using before_action
    # called method 'print_session' using before_action
    case step
    ## this is the last step - confirmation model
    when "confirm_your_email"
      find_user_by_otp
    ## this is the 2nd last step - user model
    ## user enters his/her details here
    when "your_details"
      if session && session.id && Rails.cache.fetch(session.id.to_s + "108")
        user_attrs = Rails.cache.fetch(session.id.to_s + "108")
      else
        session[:id] = {}
        user_attrs = Rails.cache.fetch(session.id.to_s + "108") { {} }
      end
      @user = User.new user_attrs
    ## this is the series of initial steps - questionnaire model
    else
      if session && session.id && Rails.cache.fetch(session.id)
        questionnaire_attrs = Rails.cache.fetch session.id
      else
        session[:id] = {}
        questionnaire_attrs = Rails.cache.fetch(session.id) { {} }
      end
      @questionnaire = Questionnaire.new questionnaire_attrs
    end
    render_wizard
  end

  def update
    # called method 'print_session' using before_action
    case step
    ## this is the last step - confirmation model
    when "confirm_your_email"
      find_user_by_otp
      if @user && @user.confirmation_sent_at >= OTP_EXPIRATION_TIME
        @user.confirm
        @user.update(confirmation_token: nil)
        redirect_to_next next_step
      else
        flash.now[:alert] = "Invalid or expired OTP. Please try again."
        render_wizard nil, status: :unprocessable_entity
      end
    ## this is the 2nd last step - user model
    ## user enters his/her details here
    when "your_details"
      if Rails.cache.fetch(session.id.to_s + "108")
        user_attrs = Rails.cache.fetch(session.id.to_s + "108").merge user_params
      else
        user_attrs = Rails.cache.fetch(session.id.to_s + "108") { {} }
        user_attrs = user_attrs.merge user_params
      end
      
      @user = User.new user_attrs

      if @user.valid?
        Rails.cache.write(session.id.to_s + "108", user_attrs)
        @user.save!
        
        questionnaire_from_cache = Questionnaire.new Rails.cache.fetch(session.id)
        questionnaire_from_cache.user = @user
        questionnaire_from_cache.save!

        redirect_to_next next_step
      else
        render_wizard nil, status: :unprocessable_entity
      end
    ## this is the series of initial steps - questionnaire model
    else
      if Rails.cache.fetch(session.id)
        questionnaire_attrs = Rails.cache.fetch(session.id).merge questionnaire_params
      else
        questionnaire_attrs = Rails.cache.fetch(session.id) { {} }
        questionnaire_attrs = questionnaire_attrs.merge questionnaire_params
      end
      
      @questionnaire = Questionnaire.new questionnaire_attrs

      if @questionnaire.valid?
        Rails.cache.write session.id, questionnaire_attrs
        redirect_to_next next_step
      else
        render_wizard nil, status: :unprocessable_entity
      end
    end
  end

  private

  def set_session_and_cache
    unless session && session.id
      session[:id] = {}
      Rails.cache.fetch(session.id) { {} }
      Rails.cache.fetch(session.id.to_s + "108") { {} }
      # print_session
    end
  end

  def redirect_to_1st_step
    # if user directly lands on some step other than 1st then gets redirected to 1st step; also if user goes back in browser, after signing up successfully, to a page other than 1st step then also gets redirected to 1st step
    if step != "how_old_are_you" && Rails.cache.fetch(session.id).empty?
      jump_to :how_old_are_you
    elsif step == "your_details"
      if Rails.cache.fetch(session.id)["form_step"] != "how_much_stock_investments_do_you_own"
        jump_to(Rails.cache.fetch(session.id)["form_step"])
      end
    elsif step == "confirm_your_email"
      if Rails.cache.fetch(session.id.to_s + "108") && Rails.cache.fetch(session.id.to_s + "108")["form_step"] != "your_details"
        jump_to(Rails.cache.fetch(session.id)["form_step"])
      end
    end
  end

  def questionnaire_params
    permitted_attributes = case step
    when "how_old_are_you"
      [:age] 
    when "where_do_you_live"
      [:pincode]
    when "what_do_you_need_help_with"
      [category_ids: []]
    when "what_is_your_annual_household_income"
      [:annual_income_in_lacs]
    when "how_much_cash_assets_do_you_own"
      [:cash_assets_in_lacs]
    when "how_much_real_estate_assets_do_you_own"
      [:real_estate_assets_in_lacs]
    when "how_much_investments_do_you_own"
      [:investments_in_lacs]
    when "how_much_retirement_investments_do_you_own"
      [:retirement_investments_in_lacs]
    when "how_much_stock_investments_do_you_own"
      [:stock_investments_in_lacs]
    end
    params.require(:questionnaire).permit(:id, permitted_attributes).merge(form_step: step)
  end

  def user_params
    permitted_attributes = case step
    when "your_details"
      [:email, :first_name, :last_name, :phone]
    when "confirm_your_email"
      [:otp]
    end
    params.require(:user).permit(:id, permitted_attributes).merge(form_step: step)
  end

  def finish_wizard_path
    user_attrs = Rails.cache.fetch(session.id.to_s + "108")
    @user = User.find_by_email user_attrs["email"]
    Rails.cache.delete session.id
    Rails.cache.delete session.id.to_s + "108"
    # autogen password for the user
    pass = SecureRandom.hex(6)
    @user.update(password: pass)
    # auto signin the user
    DashboardMailer.thankyou(@user, pass).deliver_later
    sign_in(@user)
    after_sign_in_path_for(@user)
  end

  def print_session
    if session.id
      puts "Session ID = "
      puts session.id
      puts "Session ID + 108 = "
      puts session.id.to_s + "108"
      puts "Cache Session ID = "
      puts Rails.cache.fetch(session.id)
      puts "Cache Session ID + 108 = "
      puts Rails.cache.fetch(session.id.to_s + "108")
    end
  end

  def find_user_by_otp
    @user = User.find_by_confirmation_token(permitted_params[:otp])
  end

  # used to validate token :POST
  def permitted_params
    params.fetch(:user, {}).permit(:otp)
  end
end
