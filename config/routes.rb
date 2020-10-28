Rails.application.routes.draw do
  # if Rails.env.development?
  #  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  # end

  # post '/graphql', to: 'graphql#execute'

  match '/auth/:provider/callback', to: 'sessions#create', via: %i[get post], as: :auth_callback
  match '/auth/failure', to: 'sessions#failure', via: %i[get post]
  match '/auth/signout', to: 'sessions#destroy', via: %i[delete]

  get 'welcome', to: 'welcome#index'

  get 'apps/ableton', to: 'apps/ableton#index'
  get 'apps/teamschedule', to: 'apps/teamschedule#index'
  
  mount SetLive::Engine, at: "/setlive"
  mount SetPlanner::Engine, at: "/setplanner"
  mount PCO::Engine, at: "/pco"

  # Routes for connecting an organization to Planning Center
  scope '/pco', as: 'pco' do
    scope '/:organization_id' do
      get '/auth', to: 'planning_center#auth'
      get '/has_token', to: 'planning_center#token?'
    end

    match '/callback', to: 'planning_center#complete', via: %i[get post]
  end

  scope '/spotify', as: 'spotify' do
    scope '/:organization_id' do
      get '/auth', to: 'spotify#auth'
      get '/has_token', to: 'spotify#token?'
    end

    match '/callback', to: 'spotify#complete', via: %i[get post]
  end

  # API Routes
  namespace :api do
    namespace :teamschedule do
      namespace :v1 do
        scope '/:organization_id' do
          scope '/schedule' do
            get 'team', to: 'schedule#show'
            post 'refresh', to: 'schedule#refresh'
          end
        end
      end
    end
  end

  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
