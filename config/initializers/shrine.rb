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
  cache: Shrine::Storage::S3.new(prefix: "cache", upload_options: { acl: "public-read" }, **s3_options),
  store: Shrine::Storage::S3.new(upload_options: { acl: "public-read" }, **s3_options)
}

Shrine.plugin :activerecord
Shrine.logger = Rails.logger
Shrine.plugin :instrumentation
Shrine.plugin :determine_mime_type
Shrine.plugin :cached_attachment_data  # enables retaining cached file across form redisplays
Shrine.plugin :restore_cached_data     # extracts metadata for assigned cached files
Shrine.plugin :derivatives, versions_compatibility: true # handle versions column format

Shrine.plugin :presign_endpoint, presign_options: -> (request) {
  # Uppy will send the "filename" and "type" query parameters
  filename = request.params["filename"]
  type     = request.params["type"]

  {
    content_disposition:    ContentDisposition.inline(filename), # set download filename
    content_type:           type,                                # set content type (defaults to "application/octet-stream")
    content_length_range:   0..(10*1024*1024),                   # limit upload size to 10 MB
    success_action_status:  '201'
  }
}

Shrine.plugin :backgrounding
Shrine::Attacher.promote_block { Attachment::PromoteJob.perform_in(3, record, name, file_data) }
Shrine::Attacher.destroy_block { Attachment::DestroyJob.perform_later(data) }
