require "image_processing/mini_magick"

class ImageUploader < Shrine
  # ALLOWED_TYPES  = %w[image/jpeg image/png image/webp]
  # MAX_SIZE       = 10*1024*1024 # 10 MB
  # MAX_DIMENSIONS = [5000, 5000] # 5000x5000

  plugin :remove_attachment
  plugin :pretty_location
  # plugin :validation_helpers
  plugin :store_dimensions, analyzer: :mini_magick

  # Attacher.validate do
  #   validate_size 0..MAX_SIZE

  #   if validate_mime_type ALLOWED_TYPES
  #     validate_max_dimensions MAX_DIMENSIONS
  #   end
  # end

  Attacher.derivatives_processor do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      normalized: magick.resize_to_limit!(1600, 1600),
      medium: magick.resize_to_limit!(500, 500),
      small: magick.resize_to_limit!(300, 300),
      thumb: magick.resize_to_limit!(100, 100)
    }
  end
end

