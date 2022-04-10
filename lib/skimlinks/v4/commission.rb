module Skimlinks
  module V4
    class Commission < OpenStruct
      def click_custom_id_json
        if click_details.present? && click_details[:custom_id]
          JSON.parse(click_details[:custom_id]).with_indifferent_access
        end
      end
    end
  end
end
