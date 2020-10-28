module PCO
  class Plan < ApplicationRecord
    belongs_to :pco_service_type, :class_name => 'PCO::ServiceType'
    has_many :pco_plan_items, class_name: 'PCO::PlanItem', foreign_key: "pco_plan_id"

    def songs
      pco_plan_items
        .where(item_type: 'song')
        .order(:service_sequence)
    end

  end
end
