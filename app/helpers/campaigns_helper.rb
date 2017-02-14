module CampaignsHelper
  def status_transition_button(event, campaign, text=nil)
    text ||= "#{event.to_s} Campaign".titleize
    simple_form_for campaign, namespace: event, html: { class: 'single_action', id: dom_id(campaign, event) } do |f|
      f.input(:status_event, as: :hidden, input_html: { value: event.to_s }) +
      (%i(submit approve).include?(event) ? f.input(:terms_of_service, as: :boolean, required: true, label: "I have read and agree to the #{link_to('terms of service', page_path('terms-of-use'), target: '_blank')}".html_safe) : '') +
      f.button(:submit, text, name: 'status_transition')
    end
  end

  def twitter_button(campaign)
    query = {
      button_hashtag: 'ImpactMyTeam',
      text: "Impact My Team by donating to '#{campaign.title}' for #{campaign.school.name}"
      }.to_query
    link_to(
      'Tweet', "https://twitter.com/intent/tweet?#{query}",
      class: "twitter-hashtag-button",
      target: '_blank',
      data: {
        size: "large",
        url: campaign_url(campaign),
        dnt: "true"
      }
    ) +
    javascript_tag do
      "!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');".html_safe
    end
  end

  def facebook_share_button(campaign)
    link_to(
      'Share', '#',
      onclick: %Q{
          window.open(
            'https://www.facebook.com/sharer/sharer.php?u='+encodeURIComponent(location.href),
            'facebook-share-dialog',
            'width=626,height=436');
          return false;
        }.html_safe,
      class: 'fb-share'
    )
  end

  def facebook_send_button(campaign)
    content_tag(:div, '', id: 'fb-root') +
    javascript_tag do
      %Q{
        (function(d, s, id) {
          var js, fjs = d.getElementsByTagName(s)[0];
          if (d.getElementById(id)) return;
          js = d.createElement(s); js.id = id;
          js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
          fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));
      }.html_safe
    end +
    content_tag(:div, '',
      class: 'fb-send',
      data: {
        href: campaign_url(campaign),
        font: 'arial'
      }
    )
  end
end
