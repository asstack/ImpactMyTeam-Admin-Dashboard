class Ability
  include CanCan::Ability

  # Anyone, whether an existing user or not, has the ability to view campaigns
  # that have at one point been activated, and can view any schools that are in
  # the system.
  #
  # Only users who have registered, however, are allowed to create and manage a
  # campaign.
  #
  # By extension, a user should be able to edit a campaign's shopping cart and
  # slideshow images.
  def initialize(user)
    @user = user || User.new # for guest
    @user.roles.each { |role| send(role.name.downcase) if respond_to?(role.name.downcase) }
    @user.school_roles.each { |role| send(role.name.downcase) if respond_to?(role.name.downcase) }

    # Anyone, including guests
    can :read, School
    can :read, Campaign, status: %w(active closed)

    if @user.persisted?
      can :create, School
      can :create, Campaign
      can :read, Campaign, creator_id: @user.id

      can [:submit, :update, :destroy], Campaign,
          creator_id: @user.id,
          status: %w(unsaved draft awaiting_approval rejected)

      can :cancel, Campaign,
          creator_id: @user.id,
          status: %w(awaiting_approval awaiting_contract pending_activation rejected)

      can :activate, Campaign,
          creator_id: @user.id,
          status: 'pending_activation'

      can [:read, :update], ShoppingCart, campaign: { creator_id: @user.id }
    end
  end

  def admin
    can :manage, :all

    # Except where other logic supercedes
    # i.e. state machine transitions
    Campaign.state_machine(:status).events.map(&:name).each do |event|
      cannot event, Campaign do |campaign|
        !(campaign.send "can_#{event}?")
      end
    end
  end

  def school_admin
    can :update, School, id: @user.schools.managed.verified.pluck(:id)

    can :approve, Campaign,
        creator_id: @user.id,
        status: %w(draft awaiting_approval),
        school: { id: @user.schools.managed.verified.pluck(:id) }

    can :approve, Campaign,
        school: { id: @user.schools.managed.verified.pluck(:id) },
        status: 'awaiting_approval'

    can [:read, :reject], Campaign,
        school: { id: @user.schools.managed.verified.pluck(:id) },
        status: %w(awaiting_approval awaiting_contract)

    can :activate, Campaign,
        school: { id: @user.schools.managed.verified.pluck(:id) },
        status: 'pending_activation'

    cannot :reject, Campaign, creator_id: @user.id

    can :read, Campaign,
        school: { id: @user.schools.managed.verified.pluck(:id) },
        status: %w(rejected awaiting_contract pending_activation)
  end

  # An Athletic Director is equivalent to a School Administrator
  #
  # See: SchoolRole.roles
  # See: Ability#school_admin
  def athletic_director
    school_admin
  end
end
