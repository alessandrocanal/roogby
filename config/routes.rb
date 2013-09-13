Roogby::Application.routes.draw do
  root :to => "pages#home"

  namespace :api do
    match 'players_search' => 'players#websearch', :via=>:get
    match 'teams_search' => 'teams#websearch', :via=>:get
    match 'competitions_search' => 'competitions#websearch', :via=>:get
  end
end
