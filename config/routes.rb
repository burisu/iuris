Iuris::Application.routes.draw do
  resource :site, :only => [:edit, :update]
  resources :labels
  resources :tags
  resources :templates do
    resources :comments
  end
  resources :answers do
    resources :comments
  end
  resources :questions do
    resources :comments
  end
  resources :publications do
    resources :comments
  end
  devise_for :users
  root :to => "home#index"
end
