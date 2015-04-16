module Acropolis
  module ParameterAccessor

    PARAMETER_NAMES = %w(margin exposure profit position_cost trading_fee balance budget)

    def set_parameter(name, value = nil)
      value ||= 0
      parameter = get_parameter_resource(name, value)
      parameter.update({parameter_value: value})
    end

    def get_parameter(name, default_value = nil)
      default_value ||= 0
      parameter = get_parameter_resource(name, default_value)
      parameter.parameter_value
    end

    def reset_parameter(name, default_value = nil)
      default_value ||= 0
      set_parameter(name, default_value)
    end

    #
    # Parameters
    #
    PARAMETER_NAMES.each do |method_name|
      define_method(method_name) do
        self.send(:get_parameter, method_name.to_sym, 0)
      end

      define_method("#{method_name}=") do |val|
        self.send(:set_parameter, method_name.to_sym, val)
      end

      define_method("reset_#{method_name}") do
        self.send(:reset_parameter, method_name.to_sym)
      end
    end

  end
end