module Skimlinks
  module V4
    class ReportingClient < Skimlinks::V4::AuthedClient
      REPORTING_URL = "https://reporting.skimapis.com/"

      attr_accessor :start_date
      attr_accessor :end_date
      attr_accessor :limit

      def initialize(options = {})
        options[:limit] ||= 600
        super
      end
      def fetch_commissions
        params = { access_token: access_token, start_date: start_date, end_date: end_date, limit: limit }.compact

        url = "#{REPORTING_URL}publisher/#{Skimlinks.configuration.publisher_id}/commission-report"

        has_next = true
        commisions = []
        while has_next
          results = get(url, params).parsed_response.with_indifferent_access

          has_next = results.dig(:pagination, :has_next)

          batch_commisions = results[:commissions].map do |commision_json|
            Skimlinks::V4::Commission.new(commision_json)
          end

          commisions += batch_commisions

          if has_next
            sleep 5
          end
        end

        a = 3
        commisions
      end
    end
  end
end
