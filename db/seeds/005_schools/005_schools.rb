if Rails.env.production?
  Dir[File.join(File.dirname(__FILE__), '**', '*.csv')].sort.each { |csv| School.import(File.open(csv)) }
else
  puts 'ONLY LOADING MICHIGAN SCHOOLS FOR DEVELOPMENT AND STAGING'
  Dir[File.join(File.dirname(__FILE__), '**', 'michigan.csv')].sort.each { |csv| School.import(File.open(csv)) }
end
