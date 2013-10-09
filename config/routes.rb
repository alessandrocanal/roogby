Roogby::Application.routes.draw do
  root :to => "pages#home"

  resources :pages do
    collection do
      match 'traffic_redirection' => 'pages#traffic_redirection', :via => :post
    end
  end

  resources :players
  resources :matches do
    collection do
      match 'live' => 'matches#live', :via => :get
    end
  end

  resources :teams
  resources :competitions

  namespace :api do
    match 'players_search' => 'players#websearch', :via=>:get
    match 'teams_search' => 'teams#websearch', :via=>:get
    match 'competitions_search' => 'competitions#websearch', :via=>:get
  end
end
