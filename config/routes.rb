Iuris::Application.routes.draw do
  resource :site
  resources :labels
  resources :tags
  resources :templates
  resources :messages
  resources :publications
  devise_for :users
  root :to => "home#index"
end
