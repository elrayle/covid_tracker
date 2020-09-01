Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Qa::Engine => '/api'
  resources :welcome, only: 'index'
  root 'covid_tracker/homepage#index'
end
