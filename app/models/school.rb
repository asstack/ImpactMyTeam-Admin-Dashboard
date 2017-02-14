class School < ActiveRecord::Base
  resourcify

  has_many :addresses, class_name: 'SchoolAddress', dependent: :destroy
  has_many :contacts, class_name: 'SchoolContact'
  has_many :teams, class_name: 'SchoolTeam', dependent: :destroy

  has_many :campaigns

  has_many :school_roles, dependent: :destroy
  has_many :school_affiliates, through: :school_roles, class_name: 'User', source: :user do
    # NOTE: you cannot directly build these associations. These are READ-ONLY.
    # i.e. you cannot use:
    #    user.schools.admin.build
    def verified
      merge(SchoolRole.verified)
    end

    def admin
      merge(SchoolRole.school_admin)
    end
  end

  accepts_nested_attributes_for :addresses
  accepts_nested_attributes_for :contacts

  attr_accessible :name, :city, :region, :school_level, :school_type, :website_url,
                  :athletics_url, :addresses_attributes, :contacts_attributes
  validates :name, presence: true
  validates :city, presence: true
  validates :region, presence: true
  validates :school_level, inclusion: { in: proc { School.school_levels } }
  validates :school_type, inclusion: { in: proc { School.school_types } }

  scope :none, where("1 = 0")

  include PgSearch
  pg_search_scope :search,
                  against: [:name, :city, :region],
                  using: {
                    tsearch: {
                      prefix: true
                    }
                  }

  def self.school_levels
    %w(Primary Middle Secondary University)
  end

  def self.school_types
    ['Public', 'Private', 'Charter', 'Junior College', 'Senior College']
  end

  def self.search_by_full_name(query)
    if query.present?
      search(query)
    else
      none
    end
  end

  def self.import(file)
    puts "*" * 90
    puts "Loading file: #{File.basename(file)}"
    puts "*" * 90
    CSV.foreach(file.path, headers: true) do |row|
      ActiveRecord::Base.transaction do
        hash = row.to_hash
        puts "Building School #{hash['School Name']}..."
        school_level =  if hash['School Name'] =~ /(middle|junior\shigh)(\sschool)?/i
                          'Middle'
                        elsif hash['School Name'] =~ /\sh(igh)?(\s(s|school)?)?|academy/i
                          'Secondary'
                        elsif hash['School Name'] =~ /college|university/i
                          'University'
                        else
                          'Secondary'
                        end
        school = School.find_or_create_by_name_and_city_and_region!(
          name:           hash['School Name'],
          city:           hash['City'],
          region:         hash['State'],
          school_type:    hash['School Type'],
          school_level:   school_level,
          website_url:    hash['School Website'],
          athletics_url:  hash['Athletic Website']
        )

        puts "School: #{school.name} - #{school.city}, #{school.region}"

        school.addresses.find_or_create_by_address_type(
          address_type: 'Default',
          line_1:       hash['Address'],
          line_2:       nil,
          city:         hash['City'],
          region:       hash['State'],
          postal_code:  hash['Zip Code'],
          country:      'United States',
          phone_number: hash['Phone Number']
        )

        ad = school.contacts.find_or_create_by_email(
          contact_type: 'Athletic Director',
          email:        hash['AD Email'],
          first_name:   hash['AD First'],
          last_name:    hash['AD Last'],
          phone_number: hash['AD Phone']
        )

        puts "Athletic Director: #{ad.name}"

        coach = school.contacts.find_or_create_by_email(
          contact_type: 'Coach',
          email:        hash['Fball Email'],
          first_name:   hash['Fball First'],
          last_name:    hash['Fball Last'],
          phone_number: hash['Fball Phone']
        )

        conference = AthleticConference.find_or_create_by_name(name: hash['Conference'])
        puts "Conference: #{conference}"

        fb_team = school.teams.find_or_create_by_sport(
          sport: 'Football',
          colors: hash['Colors'],
          mascot: hash['Mascot'],
          athletic_conference_id: conference.try(:id),
          website_url: hash['Athletic Website'],
          school_contact_id: (ad || coach).try(:id)
        )
        puts "Team: #{fb_team.mascot}"

        if school.persisted?
          puts "Done"
        else
          puts "Error creating school."
        end
      end
    end
  end
end
