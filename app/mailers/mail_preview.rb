class MailPreview < MailView

  def donation_successful
    DonationMailer.successful(donation 500.00)
  end

  def donation_unsuccessful
    DonationMailer.unsuccessful(donation 5001.01)
  end

  private

  def donation(amount)
    Fabricate(:donation, campaign: campaign, email: 'test@meetmaestro.com', amount_authorized: amount).tap(&:authorize)
  end

  def campaign
    Fabricate(:campaign, title: 'My Campaign', school: school, status: 'active')
  end

  def school
    Fabricate(:school, name: 'My School')
  end
end
