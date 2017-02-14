Fabricator(:campaign) do
  transient :with_donations
  creator nil
  school  nil
  team    nil
  title            { Faker::Company.bs.titleize }
  duration_in_days { [30, 60, 90].sample }
  goal_amount      { rand(500..2000).to_d }
  summary          { Faker::Lorem.paragraphs(rand(5)).join("\n\n") }
  twitter_username { Faker::Internet.user_name }
  facebook_url     { "http://www.facebook.com/#{Faker::Internet.user_name}" }

  after_create do |campaign, transients|
    if campaign.active?
      campaign.update_date_range!(start_date: Time.zone.today + rand(-20..0))

      rand(30).times do
        amount = rand(campaign.goal_amount / 50.0)
        Fabricate(:donation,
                  campaign: campaign,
                  amount_authorized: amount,
                  amount_captured: amount,
                  status: 'collected')
      end if transients[:with_donations]
    elsif campaign.closed?
      campaign.update_date_range!(start_date: Time.zone.today + rand(-120..0))
      until campaign.goal_completed?
        amount = [rand(campaign.goal_amount / 5.0), campaign.goal_remaining].max
        Fabricate(:donation,
                  campaign: campaign,
                  amount_authorized: amount,
                  amount_captured: amount,
                  status: 'collected')
      end if transients[:with_donations]
    end
  end
end
