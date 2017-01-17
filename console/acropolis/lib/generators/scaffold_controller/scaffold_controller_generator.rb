require 'rails/generators/resource_helpers'

module Rails
  module Generators
    class ScaffoldControllerGenerator < NamedBase # :nodoc:
      include ResourceHelpers

      check_class_collision suffix: "Controller"

      class_option :orm, banner: "NAME", type: :string, required: true,
                         desc: "ORM to generate the controller for"

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      def create_controller_files
        template "controller.rb", File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")

        template "../../erb/scaffold/index.html.erb", File.join('app/views', "#{controller_file_name}/index.html.erb")
        template "../../erb/scaffold/new.html.erb", File.join('app/views', "#{controller_file_name}/new.html.erb")
        template "../../erb/scaffold/edit.html.erb", File.join('app/views', "#{controller_file_name}/edit.html.erb")
        template "../../erb/scaffold/show.html.erb", File.join('app/views', "#{controller_file_name}/show.html.erb")
        template "../../erb/scaffold/_grid.html.erb", File.join('app/views', "#{controller_file_name}/_#{plural_table_name}_grid.html.erb")
        template "../../erb/scaffold/_search_form.html.erb", File.join('app/views', "#{controller_file_name}/_search_form.html.erb")

        route_string = "post '#{controller_file_name}/search' => '#{controller_file_name}#index', as: :search_#{controller_file_name}"
        gsub_file 'config/routes.rb', route_string, ''
        route route_string
      end

      hook_for :template_engine, :test_framework, as: :scaffold

      # Invoke the helper using the controller name (pluralized)
      hook_for :helper, as: :scaffold do |invoked|
        invoke invoked, [ controller_name ]
      end
    end
  end
end
