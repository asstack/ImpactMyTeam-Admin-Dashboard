class Campaign < ActiveRecord::Base
  belongs_to :school
  belongs_to :team, class_name: 'SchoolTeam', foreign_key: 'school_team_id'
  belongs_to :creator, class_name: 'User'

  has_one :shopping_cart, dependent: :destroy
  delegate :items, to: :shopping_cart, prefix: :cart

  has_many :donations, dependent: :restrict
  has_many :collected_donations, class_name: 'Donation', conditions: { status: 'collected' }, readonly: true do
    def total
      sum(&:amount_captured)
    end
  end
  has_many :campaign_photos

  mount_uploader :logo_image, ImageUploader

  accepts_nested_attributes_for :shopping_cart, :campaign_photos

  attr_accessible :title, :summary, :duration_in_days, :facebook_url, :twitter_username,
                  :terms_of_service, :school_id, :school_team_id, :status_event, :goal_amount,
                  :start_date, :end_date, :shopping_cart_attributes,
                  :logo_image, :logo_image_cache, :remove_logo_image,
                  :campaign_photos_attributes

  default_value_for :duration_in_days, 30

  after_create :create_shopping_cart

  scope :created_by, lambda { |user| where(creator_id: (user.nil? ? 0 : user.id)) }
  scope :not_created_by, lambda { |user| user ? { conditions: ['creator_id != ?', user.id] } : {} }
  scope :active, lambda { with_status(:active) }
  scope :closed, lambda { with_status(:closed) }
  scope :pending, lambda { without_statuses(:active, :closed) }
  scope :latest, lambda { |limit| order('updated_at DESC').limit(limit) }

  state_machine :status, initial: :unsaved do
    after_transition any => :active, do: :update_date_range!
    after_transition any => :active, do: :update_goal_amount!

    event :mark_as_draft do
      transition [:unsaved, :draft, :awaiting_approval, :rejected] => :draft
    end

    event :submit do
      transition [:unsaved, :draft, :rejected] => :awaiting_approval
      transition :awaiting_approval => same
    end

    event :approve do
      transition [:draft, :awaiting_approval] => :awaiting_contract
      transition :awaiting_contract => same
    end

    event :reject do
      transition [:awaiting_approval, :awaiting_contract] => :rejected
    end

    event :accept_contract do
      transition :awaiting_contract => :pending_activation
    end

    event :activate do
      transition [:pending_activation, :closed] => :active
    end

    event :close do
      transition :active => :closed
    end

    event :cancel do
      transition %i(awaiting_approval awaiting_contract pending_activation rejected) => :draft
    end

    event :reset do
      transition all => :draft
    end if Rails.env.development?

    state all - :unsaved do
      validates :title, presence: true
    end

    state all - [:unsaved, :draft] do
      validates :terms_of_service, acceptance: true
    end
  end

  def update_date_range!(start_date: nil, end_date: nil)
    start_date ||= Time.zone.today
    end_date ||= start_date + duration_in_days.days
    self.update_attributes(start_date: start_date, end_date: end_date)
  end

  def update_goal_amount!
    self.update_attributes(goal_amount: shopping_cart.order_total)
  end

  def goal_remaining
    self.shopping_cart.order_total - collected_donations.total
  end

  def goal_completed?
    collected_donations(true).total >= goal_amount
  end

  # returns a float between 0.0 and 1.0
  def goal_progress
    if goal_amount == 0
      0.0
    else
      (collected_donations(true).total / goal_amount).to_f
    end
  end
end
