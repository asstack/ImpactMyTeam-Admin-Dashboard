puts 'DEFAULT USERS'
user = User.find_or_create_by_email!(
        :first_name => ENV['ADMIN_FIRST_NAME'].dup,
        :last_name => ENV['ADMIN_LAST_NAME'].dup,
        :email => ENV['ADMIN_EMAIL'].dup,
        :password => ENV['ADMIN_PASSWORD'].dup,
        :password_confirmation => ENV['ADMIN_PASSWORD'].dup
      )
user.add_role :admin
user.add_role :me
puts 'user: ' << user.name
