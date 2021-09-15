require File.expand_path('lib/omniauth/strategies/sso', Rails.root)

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :sso, ENV['gtbox_account_client_id'], ENV['gtbox_account_secret']
end

# Labs is not vulnerable to https://nvd.nist.gov/vuln/detail/CVE-2015-9284
# because Gospel toolbox account is the only provider for labs.
OmniAuth.config.allowed_request_methods = [:get, :post]
