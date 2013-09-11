Roogby::Application.routes.draw do
  root :to => "pages#home"

  namespace :api do
    match 'players_search' => 'players#websearch', :via=>:get
  end
end
