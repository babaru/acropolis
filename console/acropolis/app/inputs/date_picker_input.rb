class DatePickerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    content = []
    class_option = input_html_options[:class]
    class_option ||= []
    class_option << "form-control"
    input_html_options[:class] = class_option

    input_html_options["data-date-format"] = 'YYYY-MM-DD'

    content << @builder.text_field(attribute_name, input_html_options)
    icon_content = template.content_tag(:span, nil, class: 'glyphicon glyphicon-calendar')
    content << template.content_tag(:span, icon_content.html_safe, class: 'input-group-addon')
    template.content_tag(:div, content.join.html_safe, :class => 'input-group date date-picker')
  end
end
