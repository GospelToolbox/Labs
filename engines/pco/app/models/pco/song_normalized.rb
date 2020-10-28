module PCO
  class SongNormalized < ApplicationRecord
    self.table_name = "pco_songs_normalized"

    def song
      PCO::Song.find(id)
    end
  end
end
