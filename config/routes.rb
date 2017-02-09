Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_scope :user do
    authenticated :user do
      root 'campaigns#index', as: :authenticated_root
      get 'campaigns_full', to: 'campaigns#full_info'
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  get 'render_xls', to: 'campaigns#render_xls', as: :to_xls
  get "home/index"
  get "home/minor"

  resources :campaigns, only: [:index, :show]
  resources :urls, only: [:show]
  get 'show_view', to: 'urls#show_view'
  get 'index_view', to: 'urls#index_view'
  get 'show_all_view', to: 'urls#show_all_view'

  get 'template', to: 'template#reactions'
  get 'template/index_view', to: 'reactions#index_view'
  get 'template/view_reactions', to: 'reactions#view_reactions'
  get 'data_reactions', to: 'reactions#data_reactions'

  resources :reactions, only: [:index]
  resources :tags, only: [:index]
  get 'votes', to: 'votes#create'
  get 'change_vote', to: 'votes#change_vote'
  get 'user', to: 'application#user'

  resources :forms

  resources :analytics do
    collection do
      get '/graphs/:id', to: 'analytics#graphs'
    end
  end
end
