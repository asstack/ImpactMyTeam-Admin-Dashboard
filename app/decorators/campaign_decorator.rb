class CampaignDecorator < Draper::Decorator
  delegate_all

  def accessibility_status
    if object.active? || object.closed? || object.rejected?
      object.status
    else
      'pending'
    end
  end

  def donation_progress_message
    count = object.collected_donations.size
    people_have = (count == 1) ? 'person has' : 'people have'
    msg = h.content_tag(:span, "#{count}", class: 'big dark') +
            " #{people_have} funded " +
            h.content_tag(:span, "#{total_collected_amount_usd}", class: 'big green') +
            " of the " + h.content_tag(:span, "#{goal_amount_usd}", class: 'big dark') + " goal."
    msg
  end

  def goal_amount_usd
    amount = object.shopping_cart.order_total
    h.number_to_currency(amount, precision: (amount.round == amount) ? 0 : 2)
  end

  def total_collected_amount_usd
    amount = object.collected_donations.total
    h.number_to_currency(amount, precision: (amount.round == amount) ? 0 : 2)
  end

  def goal_remaining_usd
    amount = object.goal_remaining
    h.number_to_currency(amount, precision: (amount.round == amount) ? 0 : 2)
  end

  def facebook_url
    h.link_to object.facebook_url, object.facebook_url
  end

  def twitter_username
    h.link_to object.twitter_username, "http://www.twitter.com/#{object.twitter_username}"
  end
end
