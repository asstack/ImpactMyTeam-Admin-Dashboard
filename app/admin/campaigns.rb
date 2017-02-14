ActiveAdmin.register Campaign do
  menu priority: 2

  actions :all, except: :destroy

  filter :status, as: :select, collection: proc { Campaign.state_machine(:status).states.map(&:name) }
  filter :school_name, as: :string
  filter :creator_first_name_or_creator_last_name, as: :string, label: 'Creator'
  filter :title
  filter :summary
  filter :goal_amount
  filter :start_date
  filter :end_date
  filter :created_at
  filter :updated_at

  scope :all, default: true

  index do
    selectable_column
    column(:logo_image) { |campaign| auto_link(campaign, image_tag(campaign.logo_image.thumb)) }
    id_column
    column(:title) { |campaign| auto_link campaign }
    column(:status)
    column(:school) { |campaign| auto_link campaign.school }
    column(:creator) { |campaign| auto_link campaign.creator }
    column(:goal_amount)
    column(:start_date)
    column(:end_date)
    column(:created_at)
    column(:updated_at)
    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :school, as: :select, input_html: { disabled: true }
      f.input :team, as: :select, collection: f.object.school.teams
      f.input :creator, as: :select, input_html: { disabled: true }
      f.input :title
      f.input :goal_amount, input_html: { min: 0.00, step: 0.01 }
      f.input :start_date, input_html: { disabled: true }
      f.input :end_date, input_html: { disabled: f.object.start_date.blank? }
      f.input :summary
      f.input :twitter_username
      f.input :facebook_url
    end

    f.inputs "Image" do
      f.input :remove_logo_image, as: :boolean if f.object.logo_image?
      f.input :logo_image, hint: f.object.logo_image.blank? ? 'No Image.' : f.template.image_tag(f.object.logo_image)
      f.input :logo_image_cache, as: :hidden
    end

    f.inputs "Change Status" do
      f.input :status_event, collection: f.object.status_events
    end

    f.inputs name: "Shopping Cart [ID: #{f.object.shopping_cart.id}]", for: :shopping_cart do |cart_f|
      cart_f.input :remove_tax_document, as: :boolean
      cart_f.input :subtotal, input_html: { min: 0.00, step: 0.01 }
      cart_f.input :taxes, input_html: { min: 0.00, step: 0.01 }
      cart_f.input :fees, input_html: { min: 0.00, step: 0.01 }
      cart_f.input :shipping, input_html: { min: 0.00, step: 0.01 }
      cart_f.input :notes
    end
    f.actions
  end

  show do |campaign|
    h1 { link_to "View #{campaign.title}", campaign_path(campaign) }
    attributes_table do
      row(:image) { image_tag(campaign.logo_image) if campaign.logo_image? }
      rows :id, :status, :title, :summary, :goal_amount
      rows :start_date, :end_date, :duration_in_days
      row(:creator) { auto_link campaign.creator }
      row(:school) { auto_link campaign.school }
      row(:team) { campaign.team.try(:name) }
      row(:school_contact) { auto_link(campaign.school.contacts.first) }

      row(:twitter_username) { link_to campaign.twitter_username, "http://www.twitter.com/#{campaign.twitter_username}" }
      row(:facebook_url) { link_to campaign.facebook_url, campaign.facebook_url }
      rows :created_at, :updated_at
    end
    panel "Shopping Cart" do
      attributes_table_for campaign.shopping_cart do
        row :id
        row(:tax_document) { |cart| link_to File.basename(cart.tax_document.path), cart.tax_document_url if cart.tax_document? }
        row(:subtotal) { |cart| number_to_currency(cart.subtotal) }
        row(:taxes) { |cart| number_to_currency(cart.taxes) }
        row(:fees) { |cart| number_to_currency(cart.fees) }
        row(:shipping) { |cart| number_to_currency(cart.shipping) }
        row(:order_total) { |cart| number_to_currency(cart.order_total) }
        row :notes
      end

      table_for campaign.shopping_cart.items do
        column :product_variant
        column :product_color
        column(:accessories) do |item|
          ul do
            item.accessories.each do |accessory|
              li auto_link(accessory)
            end
          end
        end
        column :quantity
        column(:subtotal) { |item| number_to_currency(item.subtotal) }
        column(:actions) do |item|
          span link_to("Edit", edit_admin_campaign_cart_item_path(campaign, item), class: 'member_action')
        end
      end
    end

    active_admin_comments
  end
end
