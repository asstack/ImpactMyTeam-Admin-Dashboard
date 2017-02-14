class SchoolContact < ActiveRecord::Base
  belongs_to :school

  has_many :teams, class_name: 'SchoolTeam'

  attr_accessible :contact_type, :email, :first_name, :last_name, :phone_number

  validates_presence_of :first_name, :last_name, :phone_number
  validates :contact_type, inclusion: { in: proc { SchoolContact.contact_types } }

  def self.contact_types
    ['School Administrator', 'Athletic Director', 'Coach', 'Booster', 'Other']
  end

  def name
    [first_name, last_name].compact.join(' ')
  end
end
