class User::SmsConfirmationsController < User::BaseController

  def new
    if Twilio::SendConfirmationMessage.call(current_user)
      render json: {sms: true}
    else
      # TODO finalize method
      p "HAY"
    end
  end

  def create
    if User::ConfirmPhoneNumber.call(current_user, create_params[:sms_code])
      render json: true
    else
      render action: :new, status: :unprocessable_entity, layout: !request.xhr?
    end
  end

  private

  def create_params
    params.permit(:sms_code)
  end


end
