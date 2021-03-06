class CreateSpotifyTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :spotify_tokens do |t|
      t.bigint :organization_id, null: false, index: true, unique: true
      t.string :token, null: false
      t.bigint :user_id, null: false, index: true

      t.timestamps
    end
  end
end
