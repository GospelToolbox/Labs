SetPlanner::Engine.routes.draw do

  resources :songs do
    resources :arrangements
  end

  resources :plans do 
    member do
      get :select_song

      get :gather
      get :refine
      get :enrich
      get :publish
    end

    resources :plan_songs
  end

  root 'plans#index'
end
