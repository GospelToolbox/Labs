module PCO
  class Arrangement < ApplicationRecord
    belongs_to :pco_song, :class_name => 'PCO::Song'
  end
end
