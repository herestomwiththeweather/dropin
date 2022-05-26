Rails.application.routes.draw do
  get '/today' => 'players#index', as: :today
  get '/today_count' => 'players#today_count', as: :today_count
  get '/today_player_count' => 'players#player_count', as: :today_player_count
  get '/today_goalie_count' => 'players#goalie_count', as: :today_goalie_count
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :events, only: [:index, :show]
  # Defines the root path route ("/")
  root "events#about"
  get '/cal' => 'events#index', as: :calendar
  get '/upcoming' => 'events#upcoming', as: :upcoming
  get '/search' => 'events#upcoming', as: :search
end
