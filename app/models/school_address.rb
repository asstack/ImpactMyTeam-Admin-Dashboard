class SchoolAddress < ActiveRecord::Base
  belongs_to :school

  attr_accessible :address_type, :line_1, :line_2, :city, :region, :postal_code,
                  :country, :phone_number

  validates_presence_of :line_1, :city, :region, :postal_code, :country

  validates :address_type, inclusion: { in: proc { SchoolAddress.address_types } }

  scope :default, ->{ where(address_type: 'Default') }
  scope :shipping, ->{ where(address_type: 'Shipping') }
  scope :Billing, ->{ where(address_type: 'Billing') }

  def self.address_types
    %w(Default Shipping Billing)
  end
end
