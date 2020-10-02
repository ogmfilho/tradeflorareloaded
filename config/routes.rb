Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :areas do
    patch "aprove", to: "areas#aprove"
    resources :trades, only: [ :new, :create, :destroy ]
  end

  get "my_trades", to: "pages#trades"

  get "my_proposals", to:"pages#proposals"

  get "/meu_perfil", to: "pages#meu_perfil", as: :meu_perfil

  # get "maps", to:"pages#maps"

end
