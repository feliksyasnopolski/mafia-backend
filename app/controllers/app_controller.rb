# frozen_string_literal: true

class AppController < ApplicationController
  include ActiveStorage::Streaming

  # Skip the CSRF token verification for the download_app action
  skip_before_action :verify_authenticity_token
  def upload_app
    if params[:token] == ENV['UPLOAD_APP_TOKEN']
      uploaded_app = params[:app]
      ActiveStorage::Blob.create_and_upload!(io: uploaded_app, filename: 'mafia_arena.apk',
                                             content_type: 'application/vnd.android.package-archive')
    end

    render json: { message: 'App uploaded successfully' }
  end

  def download_app
    # Find the blob with the specified filename
    blob = ActiveStorage::Blob.where(filename: 'mafia_arena.apk').order(created_at: :desc).first

    if blob.present?
      send_blob_stream(blob)
    else
      # Return a not found response if the blob is not found
      render json: { error: 'App not found' }, status: :not_found
    end
  end

  def redirect_uri
    if Rails.env.production?
      'https://mafiaarena.org/omniauth/callback'
    else
      'http://localhost:3000/omniauth/callback'
    end
  end

  def code_redirect_uri(state, token)
    is_production = Rails.env.production?
    if state == 'app'
      "mafiaarena://auth?code=#{token}"
    elsif is_production
      "https://app.mafiaarena.org/auth.html?code=#{token}"
    else
      "http://localhost:64083/auth.html?code=#{token}"
    end
  end

  def auth
    client_id = ENV['GOOGLE_APP_ID']
    client_secret = ENV['GOOGLE_APP_SECRET']
    token_request = Faraday.post('https://oauth2.googleapis.com/token', {
                                   client_id:,
                                   client_secret:,
                                   code: params[:code],
                                   access_type: 'offline',
                                   grant_type: 'authorization_code',
                                   redirect_uri:
                                   # redirect_uri: 'http://localhost:3000/omniauth/callback'
                                 })
    token = JSON.parse(token_request.body)['access_token']

    email_request = Faraday.get('https://www.googleapis.com/oauth2/v3/userinfo', nil, {
                                  'Authorization' => "Bearer #{token}"
                                })
    email = JSON.parse(email_request.body)['email']
    user_data = {
      uid: SecureRandom.hex(16),
      email:
    }

    user = User.from_google(user_data)
    if user.tokens.blank?
      user.create_token
      user.reload
    end

    token = user.create_new_auth_token
    # convert token to base64 string
    token = Base64.strict_encode64(token.to_json)

    redirect_to code_redirect_uri(params[:state], token), allow_other_host: true
  end
end
