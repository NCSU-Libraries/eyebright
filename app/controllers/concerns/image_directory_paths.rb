module ImageDirectoryPaths

  private

  def identifier_directory
    File.join Rails.root, "public/iiif/#{params[:id]}"
  end

  def image_cache_directory
    File.join(identifier_directory, "/#{params[:region]}/#{params[:size]}/#{params[:rotation]}")
  end

  def image_cache_file_path
    File.join(image_cache_directory, "#{params[:quality]}.#{params[:format]}")
  end

  def info_cache_directory
    identifier_directory
  end

  def info_cache_file_path
    File.join info_cache_directory, 'info.json'
  end

end
