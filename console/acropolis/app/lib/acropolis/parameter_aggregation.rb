module Acropolis
  module ParameterAggregation
    def param_aggregation(param, options = {})
      define_method(param) do
        return nil unless options[:from]
        collection = options[:from]
        value_method = options[:value_method] || param
        init_value = options[:init_value] || 0

        if collection.is_a? Symbol
          collection = self.send(collection)
        end

        collection.inject(init_value) {|sum, c| sum += c.send(value_method)}
      end
    end
  end
end