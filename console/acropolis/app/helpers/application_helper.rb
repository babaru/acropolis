module ApplicationHelper

  def recent_items(type)
    type = type.to_s if type.is_a?(Symbol)
    session['recent'] ||= {}
    session['recent'][type] ||= {}
    session['recent'][type]
  end

  def render_net_worth(value, options = {})
    default_options = {
      font_size:  14,
      precision:  2,
      bold: 'normal'
    }

    options = default_options.merge(options)

    value = 'n/a' if value.nil?

    content_tag(:span,
      number_with_precision(
        value,
        precision:     options[:precision]
      ), class: options[:class], style: "font-size: #{options[:font_size]}px; font-weight: #{options[:bold]}")
  end

  def render_currency(value, options = {})
    default_options = {
      font_size:  12,
      unit:       '￥',
      separator:  '.',
      delimiter:  ',',
      format:     "%u %n",
      negative_style:       'text-danger',
      null_style:           'text-muted'
    }

    options = default_options.merge(options)

    options[:class] = options[:negative_style] if value && value < 0
    options[:class] = options[:null_style] if value.nil?

    value = 'n/a' if value.nil?

    content_tag(:span,
      number_to_currency(
        value,
        unit:       options[:unit],
        separator:  options[:separator],
        delimiter:  options[:delimiter],
        format:     options[:format]
      ), class: options[:class])
  end

  def render_decimal(value, options = {})
    default_options = {
      negative_style:       'text-danger',
      null_style:           'text-muted'
    }

    options = default_options.merge(options)

    options[:class] = options[:negative_style] if value < 0
    options[:class] = options[:null_style] if value.nil?

    value = 'n/a' if value.nil?

    content_tag(:span, value, class: options[:class])
  end

  def render_percentage(value, options = {})
    default_options = {
      precision:            0,
      negative_style:       'text-danger',
      null_style:           'text-muted'
    }

    options = default_options.merge(options)

    options[:class] = options[:negative_style] if value < 0
    options[:class] = options[:null_style] if value.nil?

    value *= 100 if value
    value = 'n/a' if value.nil?

    content_tag(:span, number_to_percentage(value, precision: options[:precision]), class: options[:class])
  end

  def render_money(value, options = {})
    default_options = {
      font_size:  14,
      unit:       '￥',
      separator:  '.',
      delimiter:  ',',
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

  def render_balance(value)
    return render_money(value, color: 'inverse') if value > 0
    render_money(value, color: 'danger')
  end

  def render_budget(value)
    render_money(value)
  end

  def render_fixed_budget(value)
    render_money(value, color: 'default')
  end

  def render_trade_price(value, options = {})
    default_options = {
      side:       Acropolis::OrderSides.order_sides.buy,
      font_size:  12,
      unit:       '￥',
      separator:  '.',
      delimiter:  '',
      format:     "%u %n",
      color:      'default'
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

  def render_market_price(value, options = {})
    options = {
      delimiter: ''
    }.merge(options)
    content_tag(:strong, render_currency(value, options))
  end


  def render_order_side(value, options = {})
    default_options = {
      colors: {
        buy: 'primary',
        sell: 'danger'
        },
      font_size:  12
    }

    options = default_options.merge(options)

    key = Acropolis::OrderSides.order_sides.key(value)
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
