class DonationTransaction < ActiveRecord::Base
  belongs_to :donation
  attr_accessible :action, :amount, :response

  serialize :params, Hash

  scope :successful, where(success: true)
  scope :failed, where(success: false)

  def self.authorize(amount = nil, credit_card = nil, options = {})
    process 'authorize', amount do |gw|
      gw.authorize(amount_in_cents(amount), credit_card, options)
    end
  end

  def self.capture(amount = nil, authorization = nil, options = {})
    process 'capture', amount do |gw|
      gw.capture(amount_in_cents(amount), authorization, options)
    end
  end

  def self.void(authorization = nil, options = {})
    process 'void', amount do |gw|
      gw.void(authorization, options)
    end
  end

  private

  def self.process(action, amount = nil)
    result = DonationTransaction.new
    result.amount = amount
    result.action = action

    begin
      response = yield GATEWAY
      result.success = response.success?
      result.authorization = response.authorization
      # NOTE: Not sure what the 'Transaction Normal' thing is, but it shows up
      # on every failure mode I've tested. Removing it since it seems to just be
      # a confusing expletive.
      result.message = response.message.gsub(/Transaction\ Normal\ -\ /, '')
      result.params = response.params
    rescue ActiveMerchant::ActiveMerchantError => e
      result.success = false
      result.authorization = nil
      result.message = e.message
      result.params = {}
    end

    result
  end

  def self.amount_in_cents(amount)
    (amount * 100).round
  end
end
