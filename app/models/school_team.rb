class SchoolTeam < ActiveRecord::Base
  belongs_to :school_contact
  belongs_to :athletic_conference
  belongs_to :school
  attr_accessible :colors, :mascot, :name, :sport, :website_url,
                  :athletic_conference_id, :school_contact_id
end
