module Api
  module V1

    class ProductRiskParametersController < BaseController

      def create
        @product_risk_parameter = ProductRiskParameter.where(product_id: product_risk_parameter_params[:product_id], parameter_id: product_risk_parameter_params[:parameter_id]).first
        super.create and return if @product_risk_parameter.nil?

        if @product_risk_parameter.update(product_risk_parameter_params)
          render :show
        else
          render json: @product_risk_parameter.errors, status: :unprocessable_entity
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
