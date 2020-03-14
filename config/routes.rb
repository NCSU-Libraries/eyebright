Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Image API
  image_prefix = 'iiif'
  match "#{image_prefix}/:id/:region/:size/:rotation/:quality.:format", to: 'images#show', via: [:get, :head]
  match "#{image_prefix}/:id/info.json", to: 'images#info', via: [:get, :head]
  get "#{image_prefix}/:id", to: redirect("#{image_prefix}/%{id}/info.json")
  get "#{image_prefix}/:id/view", to: 'images#view'

  # Experimental Video API
  # Routes for an image from a video
  video_image_prefix = 'iiifvi'
  time_constraint = /(\d\d\:\d\d\:\d\d|\d+)(\.\d+)?/
  match "#{video_image_prefix}/:id/:time/:region/:size/:rotation/:quality.:format", constraints: {time: time_constraint}, to: 'videos#show_image', via: [:get, :head]
  match "#{video_image_prefix}/:id/info.json", constraints: {time: time_constraint}, to: 'videos#image_info', via: [:get, :head]
  get "#{video_image_prefix}/:id", to: redirect("#{video_image_prefix}/%{id}/info.json")

  video_prefix = 'iiifv'
  # info.json for the video
  match "#{video_prefix}/:id/info.json", to: 'videos#info', via: [:get, :head], as: :video_info
  # video viewer. route must be before redirect
  get "#{video_prefix}/viewer", to: 'videos#viewer'
  # redirect from identifier to the info.json for the video
  get "#{video_prefix}/:id", to: redirect("#{video_prefix}/%{id}/info.json")

  # API
  delete '/api/clear_image_cache'

  mount ResqueWeb::Engine => "/jobs"

end
