class AddPCOSongsNormalized < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
      CREATE VIEW pco_songs_normalized AS
        WITH song_counts as (
          SELECT
            pco_song_id as id,
            COUNT (*) as count
          FROM 
            pco_plan_items
          WHERE
            pco_song_id is not null
          GROUP BY
            pco_song_id
        ),
        song_dates as (
          SELECT
            pi.pco_song_id as id,
            extract(day from now() - MIN(p.date)) since_first_use,
            extract(day from now() - MAX(p.date)) since_last_use
          FROM 
            pco_plan_items pi
            LEFT JOIN pco_plans p on p.id = pi.pco_plan_id
          WHERE
            pco_song_id is not null
          GROUP BY
            pco_song_id
        )
        , data as (
        SELECT
          songs.*,
          counts.count as count,
          (CAST(counts.count as FLOAT) - (SELECT MIN(count) from song_counts)) / ((SELECT MAX(count) from song_counts) - (SELECT MIN(count) from song_counts)) as count_norm,
          dates.since_first_use,
          (CAST(dates.since_first_use as FLOAT) - (SELECT MIN(since_first_use) from song_dates)) / ((SELECT MAX(since_first_use) from song_dates) - (SELECT MIN(since_first_use) from song_dates)) as since_first_use_norm,
          dates.since_last_use,
          (CAST(dates.since_last_use as FLOAT) - (SELECT MIN(since_last_use) from song_dates)) / ((SELECT MAX(since_last_use) from song_dates) - (SELECT MIN(since_last_use) from song_dates)) as since_last_use_norm
        FROM
          pco_songs songs
          LEFT JOIN song_counts counts on counts.id = songs.id
          LEFT JOIN song_dates dates on dates.id = songs.id
        )
        SELECT
          *,
          ((count_norm * 0.3) + (since_first_use_norm * 0.1) + (since_last_use_norm * 0.6)) as score
        FROM
          data
    SQL
  end
  def down
    execute <<-SQL
      DROP VIEW IF EXISTS pco_songs_normalized
    SQL
  end
end
