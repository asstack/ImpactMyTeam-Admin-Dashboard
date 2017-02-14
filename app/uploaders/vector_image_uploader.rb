# encoding: utf-8
require 'carrierwave/processing/mime_types'

class VectorImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  storage ENV["USE_FOG"] == "true" ? :fog : :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :set_content_type

  def extension_white_list
    %w(ai eps cdr svg)
  end
end
