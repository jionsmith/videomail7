require 'sidekiq/web'

Rails.application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :accounts, controllers: { registrations: 'registrations' }
  devise_scope :account do
    get '/p/:referrer_code', to: 'registrations#promolink', as: 'promolink'
    match '/auth/:provider/callback', to: 'registrations#omniauth', via: [:get, :post]
    get '/auth/failure', to: redirect('/')
  end

  # Panda Routes
  scope default_format: :json do
    post '/panda/authorize_upload', to: 'panda#authorize_upload'
    post '/panda/notifications', to: 'panda#notifications'
  end

  resources :videos do
    get :preview, on: :member
    put :refresh, on: :member
    get :download, on: :member
    get :selection, on: :collection
  end

  resources :messages do
    member do
      put :deliver
      put :clone
      get :preview
      get :statistics
    end
    
    collection do
      get :contacts
      get :statistics
      put :destroy_multiple
      put :restore_multiple
      put :really_destroy_multiple
    end
  end

  resources :templates, only: [:index, :show] do
    member do
      get :preview
      delete :remove
    end
    collection do
      get :selection
      get :available
    end
  end

  resources :products, only: [:index, :show] do
    put :add_to_user, on: :member
  end

  resources :orders, only: [:index, :new, :create]

  resources :pages, only:[] do
    get :termsofuse, on: :collection
    get :imprint, on: :collection
    get :contact, on: :collection 
  end

  resources :playlists do
    put :add_video, on: :member
    put :remove_video, on: :member
    get :selection, on: :collection
  end

  get '/record', to: 'video_recorder#record'
  get '/avc_settings', to: 'video_recorder#avc_settings'
  post '/jpg_encoder_download', to: 'video_recorder#jpg_encoder_download'

  namespace :admin do
    resources :videos do
      get :preview, on: :member
      put :refresh, on: :member
    end

    resources :templates
    resources :categories
    resources :settings

    resources :products do
      put :add_category, on: :member
      put :remove_category, on: :member
    end

    resources :packages do
      get :manage_templates, on: :member
      put :add_template, on: :member
      put :remove_template, on: :member
    end

    root 'templates#index'
  end

  root 'videos#index'
end
