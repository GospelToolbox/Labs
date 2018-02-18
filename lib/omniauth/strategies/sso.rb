require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Sso < OmniAuth::Strategies::OAuth2
      option :name, :sso

      option :client_options, {
        :site => ENV.fetch('gtbox_account_host', 'http://localhost:3000'),
        :authorize_path => '/oauth/authorize'
      }

      def callback_url
        full_host + script_name + callback_path
      end

      uid do
        raw_info["id"]
      end

      info do
        {
          email: raw_info['email'],
          organizations: raw_info['organizations'] 
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/profile.json').parsed
      end
    end
  end
end