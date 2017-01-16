class InspiniaSidebarRenderer < SimpleNavigation::Renderer::Base

  def render(item_container)
    if options[:is_subnavigation]
      ul_class = "nav nav-second-level" if item_container.level.to_i == 2
      ul_class = "nav nav-third-level" if item_container.level.to_i == 3
    else
      ul_class = "nav"
    end

    list_content = item_container.items.inject([]) do |list, item|
      li_options = item.html_options.except(:link)
      if include_sub_navigation?(item)
        li_options[:class] = [li_options[:class], ""].flatten.compact.join(' ')
      end
      li_content = tag_for(item)
      if include_sub_navigation?(item)
        li_content << render_sub_navigation_for(item)
      end
      list << content_tag(:li, li_content, li_options)
    end.join
    if skip_if_empty? && item_container.empty?
      ''
    else
      content_tag(:ul, list_content, { :id => 'side-menu', :class => [item_container.dom_class, ul_class].flatten.compact.join(' ') })
    end
  end

  def render_sub_navigation_for(item)
    item.sub_navigation.render(self.options.merge(:is_subnavigation => true))
  end

  protected

  def tag_for(item)
    if item.url.nil?
      link_to([content_tag(:span, item.name, class: 'nav-label'), content_tag(:span, nil, class: 'fa arrow')].join.html_safe, '#', link_options_for(item))
    else
      link_to(content_tag(:span, item.name, class: 'nav-label'), item.url, link_options_for(item))
    end
  end

  # Extracts the options relevant for the generated link
  #
  def link_options_for(item)
    special_options = {:method => item.method}.reject {|k, v| v.nil? }
    link_options = item.html_options[:link] || {}
    opts = special_options.merge(link_options)
    opts[:class] = [link_options[:class], item.selected_class].flatten.compact.join(' ')
    opts.delete(:class) if opts[:class].nil? || opts[:class] == ''
    opts
  end
end
