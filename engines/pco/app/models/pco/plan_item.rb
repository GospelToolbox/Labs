module PCO
  class PlanItem < ApplicationRecord
    belongs_to :pco_plan, :class_name => 'PCO::Plan'

    belongs_to :pco_song, class_name: 'PCO::Song', optional: true
    belongs_to :pco_arrangement, class_name: 'PCO::Arrangement', optional: true
    belongs_to :pco_key, class_name: 'PCO::Key', optional: true


  end
end
