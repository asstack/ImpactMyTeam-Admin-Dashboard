class SchoolRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :school
  belongs_to :verified_by, class_name: 'User'

  attr_accessible :name, :school_id, :user_id

  scope :school_admin, where( name: %w(school_admin athletic_director) )
  scope :verified, where('verified_at IS NOT NULL')
  scope :unverified, where(verified_at: nil)
  scope :latest, lambda { |limit| order('updated_at DESC').limit(limit) }
  scope :for_school, lambda { |school| where(school_id: (school ? school.id : 0)) }

  validates :name, presence: true, inclusion: { in: proc { SchoolRole.roles } }
  validates :school, presence: true
  validates :user, presence: true

  def verify!(verifier = nil)
    self.verified_at = DateTime.current
    self.verified_by = verifier
    self.save
  end

  def verified?
    !verified_at.nil?
  end

  # A note on roles:
  #
  # A 'school_admin' is equivalent to an 'athletic_director' in their abilities,
  # thus any rule that applies to a school_admin should also apply to an
  # athletic_director.
  #
  # See: SchoolRole.school_admin  # scope
  # See: User#schools.managed     # association extension
  # See: Ability#school_admin
  # See: Ability#athletic_director
  #
  # At present, there is no distinction between the two roles. However, keeping
  # the two separate makes it easier for a separation of the two roles in the
  # future.
  #
  # All other roles are arbitrary and offer no additional abilities to the user.
  def self.roles
    %w(school_admin athletic_director booster parent student other)
  end

  def self.role_mappings
    {
      'School Administrator' => 'school_admin',
      'Athletic Director' => 'athletic_director',
      'Booster' => 'booster',
      'Parent' => 'parent',
      'Student' => 'student',
      'Other' => 'other'
    }
  end
end
