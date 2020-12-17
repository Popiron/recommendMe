Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
          resources :films do
            resources :related_games
          end
          resources :games do
            resources :related_films
          end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
