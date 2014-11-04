module Api
  module V1

    class ProductsController < BaseController

      private

        def product_params
          params.require(:product).permit(:name)
        end

        def query_params
          params.permit(:id, :name)
        end

    end

  end
end
