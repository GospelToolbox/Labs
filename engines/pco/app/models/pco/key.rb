module PCO
  class Key < ApplicationRecord
    belongs_to :pco_arrangement, :class_name => 'PCO::Arrangement'

  end
end
