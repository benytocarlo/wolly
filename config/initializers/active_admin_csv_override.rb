module ActiveAdmin
  class ResourceController < BaseController
    module DataAccess
      def max_csv_records
        150_000
      end
      
      def max_per_page
        150_000
      end
    end
  end
end