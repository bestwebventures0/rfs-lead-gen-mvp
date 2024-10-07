class ConfirmationsController < ApplicationController
  OTP_EXPIRATION_TIME = 5.minutes.ago

  def confirm_otp
    find_user_by_otp
  end

  def confirm_email_for_otp
    find_user_by_email
  end


  def validate_otp
    find_user_by_otp
    if @user && @user.confirmation_sent_at >= OTP_EXPIRATION_TIME
      @user.confirm
      @user.update(confirmation_token: nil)
      redirect_to new_user_session_path, notice: "Email confirmed successfully, Please login!"
    else
      flash.now[:alert] = "Invalid or expired OTP. Please try again."
      render :confirm_otp, status: :unprocessable_entity
    end
  end

  def resend_otp
    find_user_by_email
    if @user
      unless @user.confirmed?
        @user.send_confirmation_instructions
        redirect_to confirm_otp_confirmations_path, notice: "OTP regenerated and sent to your email address."
      else
        redirect_to confirm_email_for_otp_confirmations_path, alert: "This email is already confirmed."
      end
    else
      redirect_to confirm_email_for_otp_confirmations_path, alert: "Email not found."
    end
  end

  private

  def find_user_by_otp
    @user = User.find_by_confirmation_token(permitted_params[:otp]) if permitted_params[:otp]
  end

  def find_user_by_email
    @user = User.find_by(email: params[:user][:email_address]) if permitted_params[:email_address]
  end

  def permitted_params
    params.fetch(:user, {}).permit(:email_address, :otp)
  end
end
