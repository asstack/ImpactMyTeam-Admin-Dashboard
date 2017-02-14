# setup tests in isolation

CarrierWave.configure do |config|
  if Rails.env.test? or Rails.env.cucumber?
    config.storage = :file
    config.enable_processing = false
  end

  config.cache_dir = Rails.root.join('tmp', 'uploads')

  config.fog_credentials = {
    :provider               => 'AWS',                  # required
    :aws_access_key_id      => ENV["AWS_KEY"],         # required
    :aws_secret_access_key  => ENV["AWS_SECRET"],      # required
    :region                 => 'us-east-1'             # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = ENV["AWS_FOLDER"]            # required
  config.fog_public     = ENV["FOG_PUBLIC"] == "true"  # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end
