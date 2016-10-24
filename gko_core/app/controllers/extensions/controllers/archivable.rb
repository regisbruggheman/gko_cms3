module Extensions
  module Controllers
    module Archivable

      extend ActiveSupport::Concern

      included do # Extend controller

      end

      protected

      def filter_collection(collection)
        c = super
        if params[:month].present?
          date = "#{params[:month]}/#{params[:year]}"
          @archive_date = Time.parse(date)
          @date_title = @archive_date.strftime('%B %Y')
          c = c.by_month(@archive_date).page(params[:page])
        elsif params[:year].present?
          date = "01/#{params[:year]}"
          @archive_date = Time.parse(date)
          @date_title = @archive_date.strftime('%Y')
          c = c.by_year(@archive_date).page(params[:page])
        end
        return c
      end

    end # Archivable
  end # Models
end # Extensions
