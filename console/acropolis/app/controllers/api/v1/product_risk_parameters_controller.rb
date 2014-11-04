module Api
  module V1

    class ProductRiskParametersController < BaseController

      def create
        @product_risk_parameter = ProductRiskParameter.where(product_id: product_risk_parameter_params[:product_id], parameter_id: product_risk_parameter_params[:parameter_id]).first
        if @product_risk_parameter.nil?
          @product_risk_parameter = ProductRiskParameter.new(product_risk_parameter_params)

          if @product_risk_parameter.save
            render :show, status: :created
          else
            render json: @product_risk_parameter.errors, status: :unprocessable_entity
          end
        else
          if @product_risk_parameter.update(product_risk_parameter_params)
            render :show
          else
            render json: @product_risk_parameter.errors, status: :unprocessable_entity
          end
        end
      end

      private

        def product_risk_parameter_params
          params.require(:product_risk_parameter).permit(
            :product_id,
            :parameter_id,
            :value,
            :happened_at)
        end

        def query_params
          params.permit(:id, :product_id, :parameter_id, :happened_at)
        end

    end

  end
end
