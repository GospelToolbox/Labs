PCO::Engine.routes.draw do
  scope '/sync/:organization_id', as: 'sync' do
    get '/songs', to: 'sync#sync_songs'
    get '/arrangements', to: 'sync#sync_arrangements'
    get '/keys', to: 'sync#sync_keys'

    get '/service_types', to: 'sync#sync_service_types'
    get '/plans', to: 'sync#sync_plans'
    get '/plan_items', to: 'sync#sync_plan_items'

    get 'song_tags', to: 'sync#sync_song_tags'

  end
end
