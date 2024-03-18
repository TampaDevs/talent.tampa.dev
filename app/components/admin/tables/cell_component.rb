module Admin
  module Tables
    class CellComponent < ApplicationComponent
      include CellAlignment

      private attr_reader :primary, :align

      def initialize(primary: false, align: :left)
        @primary = primary
        @align = align
      end

      def call
        tag.td content, class: class_names("px-6 py-4 whitespace-nowrap text-sm", align_class, {
          "font-medium text-blue-900": primary,
          "text-blue-950": !primary
        })
      end
    end
  end
end
