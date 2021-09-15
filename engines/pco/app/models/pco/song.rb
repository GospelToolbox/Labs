module PCO
  class Song < ApplicationRecord
    has_many :pco_arrangements, class_name: 'PCO::Arrangement', foreign_key: "pco_song_id"
    has_many :pco_plan_items, class_name: 'PCO::PlanItem', foreign_key: "pco_song_id"

    has_many :pco_song_tags, class_name: 'PCO::SongTag', foreign_key: "pco_song_id"
    has_many :pco_tags, class_name: 'PCO::Tag', through: :pco_song_tags


    def use_count
      @use_count ||= pco_plan_items.length
    end

    def first_used
      pco_plan_items.includes(:pco_plan).order("pco_plans.date").first&.pco_plan&.date
    end

    def last_used
      pco_plan_items.includes(:pco_plan).order("pco_plans.date").last&.pco_plan&.date
    end

    def age
      return nil if first_used.nil?

     ((Time.now - first_used) / 1.day).round
    end

    def last_used_days
      return nil if last_used.nil?

      ((Time.now - last_used) / 1.day).round
    end

    def frequency
      return 0 if age.nil?

      1.0 / (age / use_count) * 100
    end

    def schedule_score
      return (- 1.0/0) if frequency.zero? || last_used_days.nil?
      frequency * last_used_days
    end

    def normalized
      PCO::SongNormalized.find_by(id: id)
    end

  end
end
