class CreatePCOTags < ActiveRecord::Migration[5.1]
  def change
    create_table :pco_tags do |t|

      t.string :pco_id
      t.string :source

      t.string :value

      t.timestamps
    end
  end
end
