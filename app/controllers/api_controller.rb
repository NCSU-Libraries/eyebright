class ApiController < ApplicationController
  include ImageDirectoryPaths

  protect_from_forgery unless: -> { request.format.json? }

  before_action :authenticate_with_token

  def clear_image_cache
    params[:id] = Zaru.sanitize!(params[:image])
    if File.exists? identifier_directory
      FileUtils.rm_rf(identifier_directory)
      api_response = {success: "Cache for #{params[:id]} removed.", image: params[:id]}
      status = 200
    else
      api_response = {error: 'No directory found'}
      status = 404
    end
    render json: api_response, status: status
  end

end
