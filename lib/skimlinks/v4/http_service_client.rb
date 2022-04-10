module Skimlinks
  module V4
    class HttpServiceClient
      include HTTParty
      include ActiveModel::Model

      def self.perform_nokogiri(value)
        default_options[:perform_nokogiri] = value
      end

      attr_reader :last_error, :last_response, :last_response_nokogiri

      open_timeout 5
      read_timeout 10
      perform_nokogiri true

      def initialize(options = {})
        @last_error = nil
        super
      end

      def service
        self.class.service
      end

      def post(path, data = {}, query = {})
        inner_request 'POST', path, {}, data.as_json.to_json
      end

      def get(path, query = nil)
        request 'GET', path, query
      end

      def get_final_redirect_url(url, max_tries = 3, wait_coefficient = 5)
        cache_time = Rails.env.development? ? 30.minutes : 1.minute
        Rails
          .cache
          .fetch([:final_url, url], expires_in: cache_time, skip_nil: true) do
          retry_get(url, max_tries, wait_coefficient) { !last_error.present? }
          @last_response.headers['sa-final-url'].presence
        end
      end

      # Takes a block used for success metric
      def retry_get(url, max_tries = 3, wait_coefficient = 5, query = nil)
        max_tries = 3 if max_tries.nil?
        wait_coefficient = 5 if wait_coefficient.nil?

        try = 1
        begin
          results = get(url, query)

          success = block_given? ? yield(results) : !last_error.present?

          if success
            results
          else
            Bugsnag.leave_breadcrumb(
              'Retry get failure',
              { message: last_error&.message },
              )
            raise StandardError.new('Failed to pass checks.')
          end
        rescue => e
          #TODO: Would be awesome to log bug not enough bandwidth
          #Bugsnag.notify(StandardError.new("Failed to make request and pass checks on attempt #{try}: #{e.to_s}"))
          if try < max_tries
            sleep try * wait_coefficient # every attempt wait a little longer
            try += 1
            Rails.logger.info "Retrying get request attempt (#{try})."
            retry
          else
            Bugsnag.notify(StandardError.new("Failed to make request and pass checks on last attempt #{try}: #{e.to_s}"))
            Rails.logger.info "Failed to perform get request (#{url})."
            raise
          end
        end
      end

      protected

      def inner_request(method, path, query = {}, data = {})
        Bugsnag.leave_breadcrumb('Request to:', { path: path })

        if method.downcase == 'post'
          @last_response = self.class.post(path, body: data)
        else
          @last_response = self.class.get(path, query: query)
        end

        if option(:perform_nokogiri)
          @last_response_nokogiri = Nokogiri.HTML(@last_response)
        else
          @last_response
        end
      end

      def request(method, path, query)
        @last_response = nil
        @last_error = nil
        inner_request method, path, query
      rescue => e
        @last_error = e
        Bugsnag.notify(e)
        nil
      end

      # def put(path, query = nil)
      #   request 'PUT', path, query
      # end
      #
      # def head(path, query = nil)
      #   request 'HEAD', path, query
      # end

      private

      def option(option)
        self.class.default_options[option]
      end
    end
  end
end

# end
