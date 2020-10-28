class CreatePCOSongTags < ActiveRecord::Migration[5.1]
  def change
    create_table :pco_song_tags do |t|

      t.belongs_to :pco_song
      t.belongs_to :pco_tag

      t.timestamps
    end
  end
end
