class User < ActiveRecord::Base
  rolify

  has_many :school_roles, dependent: :destroy
  has_many :schools, through: :school_roles do
    # NOTE: you cannot directly build these scopes. These are READ-ONLY.
    # i.e. you cannot use:
    #    user.schools.managed.build
    def verified
      merge(SchoolRole.verified)
    end

    def managed
      merge(SchoolRole.school_admin)
    end
  end

  has_many :campaigns, foreign_key: :creator_id

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :phone_number,
                  :password, :password_confirmation, :remember_me

  validates_presence_of :first_name, :last_name, :email

  def name
    [first_name, last_name].compact.join(' ')
  end
end
