ActiveAdmin.register Donation do
  menu parent: 'Campaigns', priority: 2

  actions :index, :show

  filter :campaign_title, as: :string, label: 'Campaign'
  filter :ip_address
  filter :first_name
  filter :last_name
  filter :email
  filter :card_brand, as: :select, collection: proc { Donation.accepted_card_brands }
  filter :card_expires_on
  filter :amount_authorized
  filter :amount_collected
  filter :billing_address1_or_billing_address_2
  filter :billing_city
  filter :billing_state
  filter :billing_zip
  filter :billing_country
  filter :created_at
  filter :updated_at

  scope :all, default: true

  Donation.state_machine(:status).states.each do |status|
    scope status.name do |donations|
      donations.with_status(status.name)
    end
  end

  index do
    selectable_column
    id_column
    column(:campaign) { |d| auto_link d.campaign }
    column(:amount) { |d| number_to_currency(d.amount_captured) }
    column(:status) { |d| status_tag(d.status, (d.collected? ? :ok : :in_progress)) }
    column(:donor) { |d| mail_to(d.email, [d.first_name, d.last_name].join(' ')) }

    column :phone

    column(:billing_address) do |d|
      ul do
        li d.billing_address1
        li d.billing_address2 if d.billing_address2?
        li "#{d.billing_city}, #{d.billing_state} #{d.billing_zip}"
        li d.billing_country
      end
    end

    column :card_brand, sortable: false
    column('Card Expiration') { |d| d.card_expires_on.strftime('%m/%Y') }

    column("IP Address") { |d| d.ip_address }

    default_actions
  end

  show do |donation|
    panel "Donation" do
      attributes_table_for donation do
        rows :id, :campaign
        row(:amount_authorized) { number_to_currency(donation.amount_authorized) }
        row(:amount_captured) { number_to_currency(donation.amount_captured) }
        row(:status) { status_tag(donation.status, (donation.collected? ? :ok : :in_progress)) }
        rows :created_at, :updated_at
      end
    end

    panel "Donor" do
      attributes_table_for donation do
        rows :ip_address, :first_name, :last_name
        row(:email) { mail_to(donation.email, donation.email) }
        row :phone
      end
    end

    panel "Card" do
      attributes_table_for donation do
        rows :card_brand, :card_expires_on
      end
    end

    panel "Billing Address" do
      attributes_table_for donation do
        rows :billing_address1, :billing_address2, :billing_city, :billing_state
        rows :billing_zip, :billing_country
      end
    end

    panel "Transactions" do
      table_for donation.transactions do
        column :action
        column(:amount) { |t| number_to_currency(t.amount) }
        column(:success)
        column :message
        column :created_at
        column :updated_at
      end
    end

    active_admin_comments
  end
end
