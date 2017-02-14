require 'spec_helper'
require 'carrierwave/test/matchers'

describe ImageUploader do
  include CarrierWave::Test::Matchers

  before(:all) do
    puts "\n-- Testing Uploader: ImageUploader\n"
    ImageUploader.enable_processing = true
    ImageUploader.storage :file
    @uploader = ImageUploader.new(Fabricate.build(:campaign), :logo_image)
    @uploader.store!(File.open(Rails.root.join('spec', 'support', 'files', 'avatar_sample.jpg')))
  end

  after(:all) do
    ImageUploader.enable_processing = false
    ImageUploader.storage ENV['USE_FOG'] == 'true'
    @uploader.remove!
  end

  context "the original version" do
    it "has an image mime-type" do
      expect(@uploader.file.content_type).to match "image/"
    end
    it "should scale down an image to fit within 800 by 800 pixels" do
      expect(@uploader).to be_no_larger_than(800, 800)
    end

    it "has a 'jpg' extension" do
      expect(@uploader.file.extension).to eq "jpg"
    end

    it "has mime-type 'image/jpeg'" do
      expect(@uploader.file.content_type).to eq "image/jpeg"
    end
  end

  context 'the figure version' do
    it "should scale down an image to fit within 225 by 225 pixels" do
      expect(@uploader.figure).to be_no_larger_than(225, 225)
    end

    it "has a 'jpg' extension" do
      expect(@uploader.figure.file.extension).to eq "jpg"
    end

    it "has mime-type 'image/jpeg'" do
      expect(@uploader.figure.file.content_type).to eq "image/jpeg"
    end
  end

  context 'the small version' do
    it "should scale down an image to fit within 175 by 130 pixels" do
      expect(@uploader.small).to be_no_larger_than(175, 130)
    end

    it "has a 'jpg' extension" do
      expect(@uploader.small.file.extension).to eq "jpg"
    end

    it "has mime-type 'image/jpeg'" do
      expect(@uploader.small.file.content_type).to eq "image/jpeg"
    end
  end

  context 'the thumb version' do
    it "should scale down an image to fit within 50 by 50 pixels" do
      expect(@uploader.thumb).to be_no_larger_than(50, 50)
    end

    it "has a 'jpg' extension" do
      expect(@uploader.thumb.file.extension).to eq "jpg"
    end

    it "has mime-type 'image/jpeg'" do
      expect(@uploader.thumb.file.content_type).to eq "image/jpeg"
    end
  end
end
