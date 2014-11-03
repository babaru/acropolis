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

        copy_file "../../erb/scaffold/new.js.erb", File.join('app/views', "#{controller_file_name}/new.js.erb")
        copy_file "../../erb/scaffold/edit.js.erb", File.join('app/views', "#{controller_file_name}/edit.js.erb")
        copy_file "../../erb/scaffold/delete.js.erb", File.join('app/views', "#{controller_file_name}/delete.js.erb")
        copy_file "../../erb/scaffold/create.js.erb", File.join('app/views', "#{controller_file_name}/create.js.erb")
        copy_file "../../erb/scaffold/update.js.erb", File.join('app/views', "#{controller_file_name}/update.js.erb")
        copy_file "../../erb/scaffold/destroy.js.erb", File.join('app/views', "#{controller_file_name}/destroy.js.erb")

        template "../../erb/scaffold/_save.js.erb", File.join('app/views', "#{controller_file_name}/_save.js.erb")
        template "../../erb/scaffold/_new.html.erb", File.join('app/views', "#{controller_file_name}/_new.html.erb")
        template "../../erb/scaffold/_edit.html.erb", File.join('app/views', "#{controller_file_name}/_edit.html.erb")
        template "../../erb/scaffold/_delete.html.erb", File.join('app/views', "#{controller_file_name}/_delete.html.erb")

        template "../../erb/scaffold/index.html.erb", File.join('app/views', "#{controller_file_name}/index.html.erb")
        template "../../erb/scaffold/_modal_form.html.erb", File.join('app/views', "#{controller_file_name}/_modal_form.html.erb")

        template "../../erb/scaffold/_grid.html.erb", File.join('app/views', "#{controller_file_name}/_#{controller_file_name}_grid.html.erb")
        template "../../erb/scaffold/_title_panel.html.erb", File.join('app/views', "#{controller_file_name}/_#{controller_file_name}_title_panel.html.erb")
        template "../../erb/scaffold/_sidebar_menu.html.erb", File.join('app/views', "#{controller_file_name}/_#{controller_file_name}_sidebar_menu.html.erb")
      end

      hook_for :template_engine, :test_framework, as: :scaffold

      # Invoke the helper using the controller name (pluralized)
      hook_for :helper, as: :scaffold do |invoked|
        invoke invoked, [ controller_name ]
      end
    end
  end
end