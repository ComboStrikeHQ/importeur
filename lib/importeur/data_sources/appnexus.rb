# frozen_string_literal: true

module Importeur
  module DataSources
    class Appnexus
      def initialize(appnexus_service)
        @appnexus_service = appnexus_service
      end

      def dataset_unique_id
        md5 = Digest::MD5.new
        items.each { |item| md5.update(item.to_s) }
        md5.hexdigest
      end

      def items
        @items ||= appnexus_service.get_all
      end

      private

      attr_reader :appnexus_service
    end
  end
end
