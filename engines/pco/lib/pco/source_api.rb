module PCO
  class SourceApi
    TOKEN_EXPIRATION_PADDING = 300

    def initialize(organization_id)
      @org_id = organization_id
    end

    def service_types
      enumerate_paged_response do |offset,per_page|
        api.services.v2.service_types.get(offset: offset, per_page: per_page)
      end
    end

    def plans(service_type_id)
      enumerate_paged_response do |offset,per_page|
        api.services.v2.service_types[service_type_id].plans.get(offset: offset, per_page: per_page)
      end
    end

    def plan_items(service_type_id, plan_id) 
      enumerate_paged_response do |offset,per_page|
        api.services.v2.service_types[service_type_id].plans[plan_id].items.get(offset: offset, per_page: per_page)
      end
    end

    def songs
      enumerate_paged_response do |offset,per_page|
        api.services.v2.songs.get(offset: offset, per_page: per_page)
      end
    end

    def song(song_id)
      api.services.v2.songs[song_id].get()['data']
    end

    def song_tags(song_id)
      enumerate_paged_response do |offset,per_page|
        api.services.v2.songs[song_id].tags.get(offset: offset, per_page: per_page)
      end
    end

    def song_arrangements(song_id)
      enumerate_paged_response do |offset,per_page|
        api.services.v2.songs[song_id].arrangements.get(offset: offset, per_page: per_page)
      end
    end

    def song_arrangement(song_id, arrangement_id)
      api.services.v2.songs[song_id].arrangements[arrangement_id].get()['data']
    end

    def song_arrangement_keys(song_id, arrangment_id)
      enumerate_paged_response do |offset,per_page|
        api.services.v2.songs[song_id].arrangements[arrangement_id].keys.get(offset: offset, per_page: per_page)
      end
    end

    def song_arrangement_key(song_id, arrangement_id, key_id)
      api.services.v2.songs[song_id].arrangements[arrangement_id].keys[key_id].get()['data']
    end

    protected

    def enumerate_paged_response(per_page: 25)
      offset = 0
      fetch_more = true

      all_data = []

      while fetch_more
        response = begin
          yield(offset, per_page)
        rescue => err
          $stderr.puts err
          break
        end
        
        break unless response

        page_data = response['data']
        all_data.concat(page_data)
        fetch_more = page_data.length == per_page
        offset = offset + per_page
      end

      all_data
    end

    def api
      @api ||= PCO::API.new(oauth_access_token: token.token)
    end

    def token
      @token_container ||= PlanningCenterToken.find_by(organization_id: @org_id)
      return if @token_container.nil?
  
      token_hash = JSON.parse(@token_container.token)
      token_hash['access_token']
  
      token = OAuth2::AccessToken.from_hash(client, token_hash.dup)
  
      if token.expires? && (token.expires_at < Time.now.to_i + TOKEN_EXPIRATION_PADDING) && token.refresh_token
        token = token.refresh!
        @token_container.token = token.to_json
        @token_container.save
      end
  
      token
    end
  
    def client
      OAuth2::Client.new(
        ENV['pco_client_id'],
        ENV['pco_secret'],
        site: 'https://api.planningcenteronline.com'
      )
   end
  end
end