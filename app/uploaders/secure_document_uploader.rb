# encoding: utf-8
require 'carrierwave/processing/mime_types'

class SecureDocumentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes

  storage ENV['USE_FOG'] == 'true' ? :fog : :file

  def initialize(*)
    super

    if ENV['USE_FOG'] == 'true'
      self.fog_directory = ENV['SECURE_AWS_FOLDER']
      self.fog_public = false
    end
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :set_content_type

  def extension_white_list
    %w(pdf doc docx)
  end
end
