class CampaignPhoto < ActiveRecord::Base
  # Relationships
  belongs_to :campaign

  # Set this up with the uploader
  mount_uploader :image, ImageUploader

  # Props
  attr_accessible :image, :image_cache, :remove_image
end
