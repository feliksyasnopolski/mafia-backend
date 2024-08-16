# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]
  skip_before_action :verify_authenticity_token, only: :create

  
  def handle_omniauth(provider)
    werwer
    @user = User.from_omniauth(request.env["omniauth.auth"])
    
    if @user.persisted?
      render json: { status: 'success', message: "Successfully authenticated via #{provider.capitalize}", user: @user }
    else
      render json: { status: 'error', message: 'Authentication failed', errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def google_oauth2
    user = User.from_google(from_google_params)

    if user.present?
      sign_out_all_scopes
      flash[:notice] = t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect user, event: :authentication
    else
      flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
      redirect_to new_user_session_path
    end
   end

   def from_google_params
     @from_google_params ||= {
       uid: auth.uid,
       email: auth.info.email
     }
   end

   def auth
     @auth ||= request.env['omniauth.auth']
   end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end


# class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
#   skip_before_action :verify_authenticity_token
#   skip_before_action :authenticate_request




# end