class AddHiddenToSong < ActiveRecord::Migration[5.1]
  def change
    add_column :pco_songs, :hidden, :boolean, default: false
  end
end
