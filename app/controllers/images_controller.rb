class ImagesController < ApplicationController

  include ImageDirectoryPaths

  before_action :validate_request, only: [:show]

  def show
    jp2_filepath = Resolver.path(params[:id])
    if File.exist? jp2_filepath
      extractor = Extractor.new(request.path, params)
      image_path = extractor.extract

      if File.size? image_path
        FileUtils.mkdir_p image_cache_directory
        FileUtils.mv image_path, image_cache_file_path
        FileUtils.chmod_R "ugo=rwX", image_cache_directory

        send_file image_cache_file_path, type: Mime::Type.lookup_by_extension(params[:format]), disposition: 'inline'
      else
        head 500
      end
    else
      head 404
    end
  end

  def info
    # If this route is hit then the info.json is not cached to the filesystem.
    # The informer takes the fastest path to getting the information.
    @informer = Informer.new params[:id]
    @informer.inform
    id_url = File.join("#{request.protocol}#{request.host_with_port}", 'iiif', params[:id])

    # TODO: find a way where this header only gets set once even behind Apache
    # headers['Access-Control-Allow-Origin'] = '*'
    # headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    # headers['Access-Control-Request-Method'] = '*'
    # headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

    content_type = if request.format.to_s == 'application/ld+json'
      'application/ld+json'
    else
      'application/json'
    end

    json = @informer.iiif_info.to_json
    render json: json, content_type: content_type
  end

  def view
    @info_json_url = File.join IiifUrl.base_url, params[:id], 'info.json'
  end

  def validate_request
    validator = IiifRequestValidator.new(request.path)
    if !validator.valid?
      head 400
      return
    end
  end

end
