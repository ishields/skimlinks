module Skimlinks
  module V4
    class AuthedClient < ::Skimlinks::V4::HttpServiceClient
      ACCESS_TOKEN_URL = 'https://authentication.skimapis.com/access_token'

      HEADERS = {
        'Content-Type' => 'application/json',
      }

      headers HEADERS
      perform_nokogiri false


      private
      # get a cached access token to use for requests
      def access_token
        access_params = {
          'client_id': Skimlinks.configuration.client_id,
          'client_secret': Skimlinks.configuration.client_secret,
          'grant_type': 'client_credentials'
        }

        Rails.cache.fetch([:skimlinks_expire_token], expires_at: 1.hour, skip_nil: true) do |t|
          response = post(ACCESS_TOKEN_URL, access_params)
          response.parsed_response['access_token']
        end
      end
    end
  end
end
