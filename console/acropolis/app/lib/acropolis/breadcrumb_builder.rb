module Acropolis
  class BreadcrumbBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder

    def render
      @elements.collect do |element|
        render_element(element)
      end.join(@options[:separator] || " &raquo; ")
    end

    def render_element(element)
      if element.path == nil
        content = compute_name(element)
      else
        content = @context.link_to_unless_current(compute_name(element), compute_path(element), element.options)
      end
      if @options[:tag]
        if element.path == nil
          @context.content_tag(@options[:tag], content, class: 'active')
        else
          @context.content_tag(@options[:tag], content)
        end
      else
        content
      end
    end

  end
end