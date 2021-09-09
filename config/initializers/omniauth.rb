require File.expand_path('lib/omniauth/strategies/sso', Rails.root)

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :sso, ENV['gtbox_account_client_id'], ENV['gtbox_account_secret']
end

OmniAuth.config.allowed_request_methods = [:get, :post]
