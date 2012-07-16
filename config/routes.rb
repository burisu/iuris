Iuris::Application.routes.draw do
  get :search, :controller => :home

  devise_for :users, :path_prefix => 'auth'

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

  resources :parameters
  resources :publication_natures
  resources :labels do
    collection do
      get :unroll
    end
  end
  resources :tags, :except => [:index, :show]

  resources :users
  root :to => "home#index"
end
