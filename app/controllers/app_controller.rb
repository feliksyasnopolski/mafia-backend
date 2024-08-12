# frozen_string_literal: true

class AppController < ApplicationController
  include ActiveStorage::Streaming

  # Skip the CSRF token verification for the download_app action
  skip_before_action :verify_authenticity_token
  def upload_app
    # Implement the logic to store the uploaded app in ActiveStorage
    # For example:
    uploaded_app = params[:app]
    ActiveStorage::Blob.create_and_upload!(io: uploaded_app, filename: 'mafia_arena.apk',
                                           content_type: 'application/vnd.android.package-archive')
    # Store the uploaded app using ActiveStorage
    # ...

    # Return a success response
    render json: { message: 'App uploaded successfully' }
  end

  def download_app
    # Find the blob with the specified filename
    blob = ActiveStorage::Blob.find_by(filename: 'mafia_arena.apk')

    if blob.present?
      send_blob_stream(blob)
    else
      # Return a not found response if the blob is not found
      render json: { error: 'App not found' }, status: :not_found
    end
  end
end
