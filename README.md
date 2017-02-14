IA-01 Crowdfunding Website
==========================

# Getting Started

## Pre-requisites

1. Install [RVM](https://rvm.io/rvm/install/) - the first option should be sufficient
2. Install Ruby 2.0.0
  - `$ rvm install 2.0.0`
  - `$ rvm --default use 2.0.0` *Optional to use Ruby 2.0.0 by default*
3. Install [PostgreSQL](http://postgresapp.com/) and make sure it's running
4. For integration/feature testing, we are now using Poltergeist (instead of Selenium) to speed things up. This requries that you first [install PhantomJS](https://github.com/jonleighton/poltergeist#installing-phantomjs)

## Application Setup
1. Clone the repo `$ git clone git@github.com:MaestroElearning/ia01-crowdfunding-site.git`
2. Navigate to the repo directory.
  - Confirm you're using Ruby 2.0.0 through RVM: `$ which ruby`
3. Run the bundler `$ bundle`
4. Set up configuration files:
  - `$ cp config/database.example.yml config/database.yml`
  - Change your Postgres login credentials for your test and development databases
  - `$ cp config/application.example.yml config/application.yml`
  - copy the results of `$ rake secret` to the `config/application.yml` `APP_SECRET_TOKEN` variable
5. Make sure Postgres is running and run:
  - `$ rake db:setup`
6. *Optional* Add the line `--format Fuubar` to your .rspec file for prettier spec output

To populate the database with demo data, run `$ rake db:populate`. Note that this will drop the old database, so you may need to log in again using whatever credentials you seed with.

## Running the Application

This app uses Guard to watch for changes that require restarts or the running of specs. This configuration of guard runs both the spec watcher and the rails server.

To start the app, run the following commands:

```
$ rake db:test:prepare # only after running rake db:populate, db:setup, or db:migrate
$ bundle exec guard
```

## Testing

We are using RSpec for testing, so all tests are in the spec/ directory.

For integration testing, we are using RSpec with Capybara, and Poltergeist (with PhantomJS) for testing our javascript-enabled tests.

## First Data and VCR Playback

A number of tests require integration with a FirstData gateway terminal. You must have an account set up to run these tests successfully. To run these tests, set up a [First Data Global Gateway e4 Demo Account](https://firstdata.zendesk.com/entries/21510561-first-data-global-gateway-e4sm-demo-accounts), and add your terminal credentials to your local `config/application.yml`:

```yaml
GATEWAY_ID: XX0000-00 # found by clicking your terminal under the Administration tab
GATEWAY_PASSWORD: password # found by generating a password in the same place you found your Gateway ID
```

*If your specs were run before these credentials were set up*, add these credentials, remove VCR recordings (`$ rm -rf spec/vcr/`), and restart guard. The files in the `spec/vcr/` directory should not be tracked by git. They are generated whenever a remote HTTP request is made, recording the request and its response. In future runs of the test, these requests are intercepted, and the recordings are played back instead. This is meant to speed up specs and reduce dependency on the outside service, but may cause unexpected failures. If you changed anything involving a donation, and your specs are failing regardless of your changes, try removing the vcr recordings.

Furthermore, when changing or writing new specs, you may get an error from VCR asking if you expected an outgoing HTTP request. Specs that fail because of this should have the `:vcr` option set somewhere in their hierarchy:

```ruby
describe 'donation stuff', :vcr do
  it 'gets the payment' do
    # ...
  end
end

describe 'other donation stuff' do
  it 'might get the payment', :vcr do
    # ...
  end
end
```

## Contributing

1. Create a new branch with a descriptive name.
2. Run the full spec suite to ensure you're working with a clean build: `$ rake spec`
3. Write the appropriate specs for your features.
4. Write the code sufficient to make your tests pass.
5. Run your tests again. You should be using Guard as described above.
6. Check that everything works correctly in the browser.
7. If you're commits can be cleaned up, please do so using `$ git rebase -i <common_ancestor_commit>`
8. Push your changes to your branch on origin: `$ git push -u origin <branch_name>`
9. Visit Github and submit a pull request for your branch, and assign it to the project lead for review.
10. Wait for review and make any changes necessary. Repeat until merged to master.

# Related

This application is designed to work with [Impact Athletic](http://impact-athletic.com/) and their WooCommerce Shopping cart using our [WooCommerce Product API Plugin](https://github.com/MaestroElearning/IA01-WooCommerceProductAPIPlugin).
