# frozen_string_literal: true

module Importeur
  module DataSources
    class Rocketfuel
      def initialize(rocketfuel_service, params = {})
        @rocketfuel_service = rocketfuel_service
        @params = params
      end

      def dataset_unique_id
        md5 = Digest::MD5.new
        items.each { |item| md5.update(item.to_s) }
        md5.hexdigest
      end

      def items
        @items ||= rocketfuel_service.get_all(params)
      end

      private

      attr_reader :rocketfuel_service, :params
    end
  end
end
