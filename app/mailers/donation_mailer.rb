class DonationMailer < ActionMailer::Base
  default from: "noreply@impactmyteam.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.donation_mailer.unsuccessful.subject
  #
  def unsuccessful(donation)
    @donation = donation
    @campaign = donation.campaign
    @school = donation.school

    mail(
      to: @donation.donor_email(with_name: true),
      subject: "Unsuccessful donation to #{@campaign.title} [Impact My Team]"
    )
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.donation_mailer.successful.subject
  #
  def successful(donation)
    @donation = donation
    @campaign = donation.campaign
    @school = donation.school

    mail(
      to: @donation.donor_email(with_name: true),
      subject: "Successful donation to #{@campaign.title} [Impact My Team]"
    )
  end
end
