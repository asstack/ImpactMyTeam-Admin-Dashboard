class SchoolDecorator < Draper::Decorator
  delegate_all

  def location
    [city, region].compact.join(', ')
  end

  def full_name
    [name, location].compact.join(' - ')
  end
end
