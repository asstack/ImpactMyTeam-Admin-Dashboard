module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def shallow_resources(parent, child)
    child.try(:new_record?) ? [parent, child] : child
  end

  def school_search_form(options = {})
    remote = options[:remote].present? && options[:remote]
    form_id = options[:id] || ['school_search', (remote ? 'remote' : nil)].compact.join('_')

    button_options = {
      text: 'Search',
      hidden: false,
      class: 'red-button'
    }.merge!(options.delete(:button) || {})

    button_options.delete(:class) if button_options[:hidden]

    field_options = {
      placeholder: 'Find School',
      autocomplete: false,
      class: 'search-query'
    }.merge!(options.delete(:field) || {})

    form_tag schools_path, method: 'get', id: form_id do
      text_field_tag(:query, schools_query, field_options) + # CONCAT
      submit_tag(button_options.delete(:text), button_options)
    end
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
    options = {
      autolink: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end
end
