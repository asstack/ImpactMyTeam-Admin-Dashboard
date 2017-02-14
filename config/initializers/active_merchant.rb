ActiveMerchant::Billing::Base.mode = (ENV['GATEWAY_MODE'] == 'production') ? :production : :test
::GATEWAY = ActiveMerchant::Billing::StripeGateway.new(
              login: ENV['GATEWAY_ID']
            )
