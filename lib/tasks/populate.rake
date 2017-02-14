# lib/tasks/populate.rake
#
# Rake task to populate development database with test data
# Run it with "rake db:populate"
# See Railscast 126 and the faker website for more information

namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'fabrication'
    require 'faker'

    Rake::Task['db:reset'].invoke
    Rake::Task['db:seed'].invoke

    10.times do
      Fabricate(:user)
    end

    puts "Generating mock schools and campaigns..."

    School.all.each_with_index do |school, i|
      rand(10).times do
        Fabricate(:campaign,  school: school,
                              team: school.teams.sample,
                              creator: randomly_use_or_create(User),
                              status: Campaign.state_machine(:status).states.map(&:name).sample.to_s,
                              with_donations: true
                  )
      end

      print '.'
      puts i if (i % 100).zero?
    end
    puts "\nDone!"
  end
end

def randomly_use_or_create(klass, one_in_x=50)
  if (rand(one_in_x) % one_in_x).zero?
    Fabricate(klass.name.underscore.to_sym)
  else
    klass.first(offset: rand(klass.count)) || Fabricate(klass.name.underscore.to_sym)
  end
end
