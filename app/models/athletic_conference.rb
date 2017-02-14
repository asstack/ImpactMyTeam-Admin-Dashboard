class AthleticConference < ActiveRecord::Base
  has_many :teams, class_name: 'SchoolTeam'

  attr_accessible :name
end
