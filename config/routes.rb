Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :areas do
    # patch "aprove", to: "areas#aprove"
    resources :trades, only: [ :new, :create, :destroy ] do
      get "my_deal", to: "trades#deal", as: :my_deal
      patch "aprove", to: "trades#aprove"
      patch "refuse", to: "trades#refuse"
      resources :reports, only: [ :index, :new, :create,:show, :destroy ]
    end
  end
  resources :area_searches, only: [ :create, :show ]

  get "my_trades", to: "pages#trades"

  get "my_proposals", to:"pages#proposals"

  get "/meu_perfil", to: "pages#meu_perfil", as: :meu_perfil

  get "maps", to:"pages#maps"

end
