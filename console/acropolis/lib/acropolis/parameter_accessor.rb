module Acropolis
  module ParameterAccessor
    def self.included(kclass)
      kclass.class_eval do
        def self.param_accessor(*args)
          args.each do |arg|
            define_method(arg) do
              get_parameter(arg)
            end

            define_method("#{arg}=") do |val|
              set_parameter(arg, val)
            end

            define_method("reset_#{arg}") do |default_value = nil|
              reset_parameter(arg, default_value)
            end
          end
        end
      end
    end

    def setup_param_accessor_meta(param_class_name = nil, foreign_key_name = nil)
      param_class_name ||= self.class.name + "Parameter"
      @_param_class = param_class_name.constantize
      @_foreign_key = foreign_key_name || self.class.name.foreign_key
    end

    def get_parameter_resource(name, default_value)
      setup_param_accessor_meta unless @_param_class
      param = @_param_class.send(:find_by, {@_foreign_key.to_sym => self.id, parameter_name: name})
      unless param
        param = @_param_class.send(:create, {@_foreign_key.to_sym => self.id,
                                             parameter_name: name,
                                             parameter_value: default_value})
      end
      param
    end

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
  end
end