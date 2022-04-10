require 'gem_config'
require 'active_support/cache'

module Skimlinks
  include GemConfig::Base

  ApiError          = Class.new(StandardError)
  InvalidParameters = Class.new(StandardError)

  with_configuration do
    # v4
    has :client_id, classes: String
    has :client_secret, classes: String
    has :publisher_id, classes: String


    # legacy
    has :api_key, classes: String
    has :format, values: :json, default: :json
    has :cache, classes: ActiveSupport::Cache::Store
    has :cache_ttl, classes: Numeric, default: 1.day
  end
end

require 'skimlinks/version'
require 'skimlinks/client'
require 'skimlinks/merchant'
require 'skimlinks/product'
require 'skimlinks/search_helpers'
require 'skimlinks/merchant_search'
require 'skimlinks/product_search'

require 'skimlinks/v4/http_service_client'
require 'skimlinks/v4/authed_client'
require 'skimlinks/v4/reporting_client'
require 'skimlinks/v4/commission'
