Rails.application.routes.draw do


  match '/auth/:provider/callback', to: 'sessions#create', via: %i[get post], as: :auth_callback
  match '/auth/failure', to: 'sessions#failure', via: %i[get post]
  match '/auth/signout', to: 'sessions#destroy', via: %i[delete]

  get 'welcome', to: 'welcome#index'

  get 'apps/ableton', to: 'apps/ableton#index'
  get 'apps/teamschedule', to: 'apps/teamschedule#index'

  get 'pco/auth', to: 'planning_center#auth'
  match 'pco/callback', to: 'planning_center#complete', via: %i[get post]
  get 'pco/has_token', to: 'planning_center#token?'

  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
