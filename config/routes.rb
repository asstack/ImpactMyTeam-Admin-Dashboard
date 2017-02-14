Ia01CrowdfundingSite::Application.routes.draw do
  devise_for :users

  ActiveAdmin.routes(self)

  resources :schools, except: :destroy, shallow: true do
    resources :campaigns, except: :create do
      resources :donations, only: [:new, :create]
      resources :campaign_photos, only: [:create, :destroy]
    end
  end

  resources :shopping_carts, only: [:edit, :update, :show] do
    resources :cart_items, only: [:create, :update, :destroy]
  end

  resources :pages, only: :show

  get "dashboard", to: 'dashboard#index'

  root :to => "home#index"

  if Rails.env.development?
    mount MailPreview => 'mail_view'
  end
end
