# lib/tasks/populate.rake
#
# Rake task to populate development database with test data
# Run it with "rake db:populate"
# See Railscast 126 and the faker website for more information

namespace :files do
  desc "Recreate versions of all uploaded files"
  task :reprocess => :environment do
    model_image_attributes = {
      Campaign => :logo_image,
      ProductVariant => :image,
      CartItem => :custom_product_image,
      ColorOption => :image,
      CampaignPhoto => :image
    }

    model_image_attributes.each do |klass, mounted_as|
      klass.find(:all).each do |model|
        if model.respond_to? mounted_as
          uploader = model.send(mounted_as) if model.send("#{mounted_as}?")
          if uploader
            puts "reprocessing #{klass}:#{model.id}##{mounted_as}"
            uploader.recreate_versions!
          end
        end
      end
    end

  end
end
