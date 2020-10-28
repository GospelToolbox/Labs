module PCO
  class ServiceType < ApplicationRecord
    has_many :pco_plans, class_name: 'PCO::Plan', foreign_key: "pco_service_type_id"

    def upcoming_plans
      pco_plans.where("date >= ?", Date.today)
               .order(:date)

    end
  end
end
