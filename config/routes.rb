Roogby::Application.routes.draw do
  root :to => "pages#home"

  resources :pages do
    collection do
      match 'traffic_redirection' => 'pages#traffic_redirection', :via => :post
    end
  end

  resources :players
  resources :matches
  resources :teams

  namespace :api do
    match 'players_search' => 'players#websearch', :via=>:get
    match 'teams_search' => 'teams#websearch', :via=>:get
    match 'competitions_search' => 'competitions#websearch', :via=>:get
  end
end
