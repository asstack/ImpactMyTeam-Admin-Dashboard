# encoding: utf-8
require 'carrierwave/processing/mime_types'

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  storage ENV["USE_FOG"] == "true" ? :fog : :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    [version_name, "default.png"].compact.join('_')
  end

  process :set_content_type
  process resize_to_limit: [800, 800]

  version :thumb do
    process resize_to_fill: [50, 50]
  end

  version :small do
    process resize_and_pad: [175, 130]
  end

  version :figure do
    process resize_and_pad: [225, 225]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
