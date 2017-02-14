class Donation < ActiveRecord::Base
  belongs_to :campaign, touch: true
  has_many :transactions, class_name: 'DonationTransaction',
                          dependent: :restrict,
                          order: 'created_at ASC'

  attr_accessor :card_number, :card_verification

  attr_accessible :card_expires_on, :card_brand, :card_number, :card_verification,
                  :first_name, :last_name, :ip_address, :amount_authorized,
                  :amount_captured, :terms_of_service, :email, :phone,
                  :billing_address1, :billing_address2, :billing_city, :billing_state,
                  :billing_zip, :billing_country

  delegate :school, to: :campaign
  delegate :goal_remaining, to: :campaign, prefix: true

  validate :valid_credit_card, on: :create
  validates :terms_of_service, acceptance: true

  validates_presence_of :email, :billing_address1, :billing_city, :billing_state,
                        :billing_zip, :billing_country, :amount_authorized,
                        :first_name, :last_name

  validates :amount_authorized,
            numericality: {
              on: :create,
              less_than_or_equal_to: proc { |donation| donation.campaign_goal_remaining },
              greater_than: 0.00
            }

  state_machine :status, initial: :pending do
    after_failure on: :authorize, do: :deny_authorization

    event :authorize do
      transition :pending => :authorized, if: :authorize_payment
    end

    event :deny_authorization do
      transition :pending => :denied
    end

    event :collect_funds do
      transition :authorized => :collected, if: :capture_payment
    end

    # event :void do
    #   transition :authorized => :cancelled
    # end

    # event :credit do
    #   transition :collected => :refunded
    # end

    state :authorized do
      validates :amount_authorized, presence: true
    end

    state :collected do
      validates :amount_captured, presence: true
    end
  end

  def self.accepted_card_brands
    [['Visa', 'visa'], ['Mastercard', 'master'], ['Discover', 'discover'], ['American Express', 'american_express']]
  end

  def donor_email(with_name: false)
    return email unless with_name

    "#{donor_name} <#{email}>"
  end

  def donor_name
    [first_name, last_name].compact.join(' ')
  end

  def receipt
    tx = transactions(true).last
    if tx
      tx.params['ctr']
    else
      'No transaction record available.'
    end
  end

  def set_fake_info
    return unless ActiveMerchant::Billing::Base.test?
    self.attributes = {
      first_name:         'Jon',
      last_name:          'Doe',
      email:              'web@meetmaestro.com',
      card_number:        '4242424242424242',
      card_brand:         'visa',
      card_verification:  '123',
      card_expires_on:    10.months.from_now.to_date,
      billing_address1:   '401 E. Michigan',
      billing_address2:   'Suite 202',
      billing_city:       'Kalamazoo',
      billing_zip:        '49007',
      billing_state:      'Michigan',
      billing_country:    'United States',
      phone:              '800-319-2122'
    }
  end

  private

  def authorize_payment
    # make sure we're not authorizing more than once on a single donation
    last = transactions.successful.last
    return true if last && last.action == 'authorize'

    tx = DonationTransaction.authorize(amount_authorized, credit_card, purchase_options)
    transactions << tx
    tx.success
  end

  def capture_payment
    auth = transactions.successful.last
    return false unless auth && auth.action == 'authorize'

    tx = DonationTransaction.capture(auth.amount, auth.authorization, purchase_options)
    transactions << tx

    self.update_attributes(amount_captured: tx.amount) if tx.success

    tx.success
  end

  def void_transaction(transaction)
    tx = DonationTransaction.void(transaction.authorization, purchase_options)
    transactions << tx
    tx.success
  end

  def purchase_options
    {
      order_id: id, # The order number
      ip: ip_address, # The IP address of the customer making the purchase
      # customer: # The name, customer number, or other information that identifies the customer
      invoice: id, # The invoice number
      # merchant: # The name or description of the merchant offering the product
      description: "Donation to #{campaign.try(:title) || 'campaign'} via Impact My Team", # A description of the transaction
      email: email, # The email address of the customer
      # currency: # The currency of the transaction. Only important when you are using a currency that is not the default with a gateway that supports multiple currencies.
      billing_address: { # A hash containing the billing address of the customer.
        name: [first_name, last_name].compact.join(' '),
        # company: 'Company Name',
        address1: billing_address1,
        address2: billing_address2,
        city: billing_city,
        state: billing_state,
        country: billing_country,
        zip: billing_zip,
        phone: phone
      }
      # shipping_address: { # A hash containing the shipping address of the customer.
      #   name: [first_name, last_name].compact.join(' '),
      #   company: 'Company Name',
      #   address1: '123 Main St.',
      #   address2: 'P.O. Box 123',
      #   city: 'New York',
      #   state: 'NY',
      #   country: 'US',
      #   zip: '10001',
      #   phone: '5555555555'
      # }
    }
  end

  def valid_credit_card
    unless credit_card.valid?
      errors.add(:base, 'Credit card is invalid')
      credit_card.errors.each do |attr, messages|
        if attr =~ /month|year/
          attr = 'card_expires_on'
        elsif attr =~ /(first|last)_name/
          # attr = attr
        else
          attr = "card_#{attr}".gsub(/_value/, '')
        end
        messages.each { |m| errors.add(attr, m) unless errors[attr].include?(m) }
      end
    end
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      brand:              card_brand,
      number:             card_number,
      verification_value: card_verification,
      month:              card_expires_on.try(:month),
      year:               card_expires_on.try(:year),
      first_name:         first_name,
      last_name:          last_name
    )
  end
end
