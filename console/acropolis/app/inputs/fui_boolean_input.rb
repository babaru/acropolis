class FuiBooleanInput < SimpleForm::Inputs::BooleanInput
  SimpleForm.boolean_label_class = 'checkbox'
  self.default_options = {:input_html => {'data-toggle' => "checkbox", class: 'checkbox'}, :inline_label => true, :label => false}
  def nested_boolean_style?
    true
  end
end