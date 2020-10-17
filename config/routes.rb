Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope :api do
    resources :commentators, only: [:index, :show]
    resources :videos, only: [:index]
    resources :sc_threads, only: [:index, :show]
    resources :dashboard, only: [:index]
  end
end
