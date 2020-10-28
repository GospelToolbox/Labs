module PCO
  class SongTag < ApplicationRecord
    belongs_to :pco_tag, class_name: 'PCO::Tag'
  end
end
