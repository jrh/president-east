require "shrine"
require "shrine/storage/s3"

if Rails.env.production?
  s3_options = {
    access_key_id:     Rails.application.credentials.dig(:aws, :access_key_id),
    secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
    region:            'us-east-1',
    bucket:            'president-east'
  }
  
else
  s3_options = {
    access_key_id:     Rails.application.credentials.dig(:aws, :access_key_id),
    secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
    region:            'us-east-1',
    bucket:            'president-east-dev'
  }
end

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
  store: Shrine::Storage::S3.new(**s3_options),
}

Shrine.plugin :activerecord
Shrine.plugin :backgrounding
Shrine::Attacher.promote do |data|
  PromoteJob.perform_in(1, data) # perform background job in 1 second
end
Shrine.plugin :logging
Shrine.plugin :determine_mime_type
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
Shrine.plugin :presign_endpoint, presign_options: -> (request) {
  filename = request.params["filename"]
  type     = request.params["type"]

  {
    content_disposition:    "inline; filename=\"#{filename}\"", # set download filename
    content_type:           type,                               # set content type (defaults to "application/octet-stream")
    content_length_range:   0..(10*1024*1024),                  # limit upload size to 10 MB
    success_action_status:  '201'
  }
}

Shrine::Attacher.promote { |data| PromoteJob.perform_async(data) }
Shrine::Attacher.delete { |data| DeleteJob.perform_async(data) }

