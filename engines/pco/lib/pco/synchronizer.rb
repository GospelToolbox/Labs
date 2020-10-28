module PCO
  class Synchronizer
    def initialize(org_id)
      @org_id = org_id
    end

    def save_service_type(service_type)
      attrs = service_type['attributes']
      service_type = PCO::ServiceType.where(organization_id: @org_id, pco_id: service_type['id'])
                .first_or_create

      service_type.update!(
                  name: attrs['name']
                )

      service_type
    end

    def save_plan(service_type_id, plan)
      attrs = plan['attributes']
      plan = PCO::Plan.where(
            organization_id: @org_id, 
            pco_service_type_id: service_type_id,
            pco_id: plan['id']
          )
          .first_or_create

      plan.update!(
            date: attrs['dates'] == 'No dates' ? nil : Date.strptime(attrs['dates'], '%B %d, %Y'),
            title: attrs['title'],
            series_title: attrs['series_title']
          )
      plan
    end

    def save_plan_item(plan_id, item)
      attrs = item['attributes']
      rel = item['relationships']

      item = PCO::PlanItem.where(
        organization_id: @org_id, 
        pco_plan_id: plan_id,
        pco_id: item['id']
      )
      .first_or_create
      
      pco_song_id = PCO::Song.where(organization_id: @org_id, pco_id: rel.dig('song', 'data', 'id')).first&.id

      puts "PCO song Id: #{pco_song_id}"

      item.update!(
        pco_song_id: pco_song_id,
        pco_arrangement_id: PCO::Arrangement.where(organization_id: @org_id, pco_id: rel.dig('arrangement', 'data', 'id')).first&.id,
        pco_key_id: PCO::Key.where(organization_id: @org_id, pco_id: rel.dig('key', 'data', 'id')).first&.id,

        name: attrs['title'],
        description: attrs['description'],
        item_type: attrs['item_type'],
        length: attrs['length'],
        service_position: attrs['service_position'],
        service_sequence: attrs['sequence'],
        custom_arrangement_sequence: attrs['custom_arrangement_sequence']
      )
    end

    def save_song(song)
      attrs = song['attributes']
      
      song_model = PCO::Song.where(organization_id: @org_id, pco_id: song['id'])
                .first_or_create

      song_model.update!(
                title: attrs['title'],
                ccli: attrs['ccli_number'],
                themes: attrs['themes'],
                hidden: attrs['hidden']
                )
        
      song_model.themes&.split(',')&.compact&.each do |tag|
        next if tag.strip.empty?

        tag_model = PCO::Tag.where(value: tag.strip).first_or_create(source: 'song_theme', pco_id: song['id'])

        song_model.pco_tags << tag_model unless song_model.pco_tags.find_by(id: tag_model.id)
        song_model.save
      end

      song_model
    end

    def save_song_tag(tag)
      attrs = tag['attributes']
      PCO::Tag.where(value: attrs['name']).first_or_create(source: 'tag', pco_id: tag['id'])
    end

    def save_arrangement(song_id, arrangement)
      attrs = arrangement['attributes']
      arrangement = PCO::Arrangement.where(
        organization_id: @org_id, 
        pco_song_id: song_id,
        pco_id: arrangement['id']
      )
      .first_or_create

      arrangement.update!(
        name: attrs['name'],
        bpm: attrs['bpm'],
        meter: attrs['themes'],
        notes: attrs['notes'],
        length: attrs['length'],
        sequence: attrs['sequence'].to_json,
        sequence_short: attrs['sequence_short'].to_json,
        has_chords: attrs['has_chords'],
        has_chord_chart: attrs['has_chord_chart'],
        chord_chart: attrs['chord_chart'],
        chord_chart_key: attrs['chord_chart_key'],
        lyrics: attrs['lyrics']
      )

      arrangement
    end

    def save_key(arrangement_id, key) 
      attrs = key['attributes']
      key = PCO::Key.where(
        organization_id: @org_id, 
        pco_arrangement_id: arrangement_id,
        pco_id: key['id']
      )
      .first_or_create

      key.update!(
        name: attrs['name'],
        alternate_keys: attrs['alternate_keys'],
        starting_key: attrs['starting_key'],
        ending_key: attrs['ending_key'],
        starting_minor: attrs['starting_minor'],
        ending_minor: attrs['ending_minor']
      )

      key
    end
  end
end