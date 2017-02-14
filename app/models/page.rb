class Page < ActiveRecord::Base
  attr_accessible :content, :name, :permalink, :document_code

  validates :permalink, uniqueness: true

  def to_param
    permalink
  end
end
