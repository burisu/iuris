Iuris::Application.routes.draw do
  resources :parameters
  resources :publication_natures
  resources :labels, :except => [:show]
  resources :tags
  resources :tools, :only => [:index]
  get :partition, :controller => "tools"
  # resources :templates do
  #   resources :comments, :except => [:show, :index]
  # end
  resources :answers, :only => [:show, :edit, :update, :destroy] do
    resources :comments, :except => [:show, :index]
  end
  resources :questions do
    resources :answers, :only => [:new, :create]
    resources :comments, :except => [:show, :index]
  end
  resources :publications do
    resources :comments, :except => [:show, :index]
  end
  devise_for :users, :path_prefix => 'auth'
  resources :users
  root :to => "home#index"
end
