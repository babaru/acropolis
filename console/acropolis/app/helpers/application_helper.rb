module ApplicationHelper
  def recent_items(type)
    type = type.to_s if type.is_a?(Symbol)
    session['recent'] ||= {}
    session['recent'][type] ||= {}
    session['recent'][type]
  end

  def render_budget(value)
    content_tag(:div, number_with_delimiter(value, delimiter: ','), class: 'label label-success', style: 'font-size: 14px;')
  end

  def render_currency(value, unit = nil)
    number_to_currency(value, unit: unit.nil? ? "￥" : unit, separator: ".", delimiter: ",", format: "%u %n")
  end

  def render_trade_price(value, options = {})
    default_options = {
      side:       Acropolis::OrderSides.order_sides.buy,
      font_size:  14,
      unit:       '￥',
      separator:  '.',
      delimiter:  '',
      format:     "%u %n",
      color:      'info'
    }

    options = default_options.merge(options)

    content = number_to_currency(
      value,
      unit:       options[:unit],
      separator:  options[:separator],
      delimiter:  options[:delimiter],
      format:     options[:format]
    )

    content_tag(:span, content, class: "label label-#{options[:color]}", style: "font-size: #{options[:font_size]}px;")
  end

  def render_order_side(entity, options = {})
    default_options = {
      colors: {
        buy: 'primary',
        sell: 'danger'
        },
      font_size:  12
    }

    options = default_options.merge(options)

    key = Acropolis::OrderSides.order_sides.key(entity.order_side)
    content = I18n.t("order_sides.#{key}")

    content_tag(:span, content, class: "label label-#{options[:colors][key.to_sym]}", style: "font-size: #{options[:font_size]}px;")
  end

  def render_open_close(entity, options = {})
    default_options = {
      colors: {
        open: 'success',
        close: 'default'
        },
      font_size:  12
    }

    options = default_options.merge(options)

    key = Acropolis::TradeOpenFlags.trade_open_flags.key(entity.open_close)
    content = I18n.t("trade_open_flags.#{key}")

    content_tag(:span, content, class: "label label-#{options[:colors][key.to_sym]}", style: "font-size: #{options[:font_size]}px;")
  end
end
