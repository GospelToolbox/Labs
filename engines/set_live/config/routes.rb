SetLive::Engine.routes.draw do
  resources :sets do
    post 'sync'
  end

  root 'sets#index'
end
