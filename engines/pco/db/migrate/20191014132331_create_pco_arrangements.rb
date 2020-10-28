class CreatePCOArrangements < ActiveRecord::Migration[5.1]
  def change
    create_table :pco_arrangements do |t|

      t.bigint :organization_id, null: false, index: true, unique: true

      t.belongs_to :pco_song

      t.string :pco_id
      t.string :name
      t.float :bpm
      t.string :meter
      t.text :notes
      t.integer :length
      t.text :sequence
      t.text :sequence_short
      t.boolean :has_chords
      t.boolean :has_chord_chart
      t.text :chord_chart
      t.string :chord_chart_key
      t.text :lyrics 

      t.timestamps
    end
  end
end
