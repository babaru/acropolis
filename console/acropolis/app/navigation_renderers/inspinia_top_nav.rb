class InspiniaTopNav < SimpleNavigation::Renderer::Base

  def render(item_container)
    if options[:is_subnavigation]
      ul_class = "dropdown-menu"
    else
      ul_class = "nav navbar-nav"
    end

    list_content = item_container.items.inject([]) do |list, item|
      li_options = item.html_options.reject {|k, v| k == :link}
      if include_sub_navigation?(item)
        li_options[:class] = [li_options[:class], "dropdown"].flatten.compact.join(' ')
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
      ul_options = {class: [item_container.dom_class, ul_class].flatten.compact.join(' ')}
      if options[:is_subnavigation]
        ul_options = ul_options.merge( role: 'menu' )
      end
      content_tag(:ul, list_content, ul_options)
    end
  end

  def render_sub_navigation_for(item)
    item.sub_navigation.render(self.options.merge(:is_subnavigation => true))
  end

  protected

  def tag_for(item)
    if include_sub_navigation?(item)
      link_to([item.name, content_tag(:span, nil, class: 'caret')].join.html_safe, '#', link_options_for(item).merge(class: 'dropdown-toggle', data: {toggle: 'dropdown'}))
    else
      if item.url.nil?
        nil
      else
        link_to(content_tag(:span, item.name, class: 'nav-label'), item.url, link_options_for(item))
      end
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