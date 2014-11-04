module Api
  module V1

    class RiskEventsController < BaseController

      private

        def risk_event_params
          params.require(:risk_event).permit(
            :product_id,
            :operation_id,
            :remark,
            :happened_at)
        end

        def query_params
          params.permit(:id, :product_id, :operation_id, :happened_at)
        end
    end

  end
end
