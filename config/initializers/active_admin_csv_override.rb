module ActiveAdmin
  class ResourceController < BaseController
    module DataAccess
      def max_csv_records
        15_000
      end
      
      def max_per_page
        15_000
      end
    end
  end
end