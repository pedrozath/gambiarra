module Gambiarra
  module UI
    class BaseView < Gambiarra::View
      def thor
        @thor ||= begin
          thor_class = Class.new(Thor::Group) do
            include Thor::Actions
          end
          .tap { |t| t.source_root("#{Dir.pwd}") }
          .new
        end
      end

      def project_name
        Dir.pwd.split('/').last
      end

      def project_constant
        project_name.gsub('-', '_').camelize
      end
    end
  end
end
