Rails.application.routes.draw do
  namespace :v1 do
    resources :users, only: [:index, :show, :create, :update, :edit] do
      resource :setting, only: [:edit, :update]
      resources :weekly_targets, only: [:index, :create]
      resources :tags, only: [] do
        get 'search', on: :collection
        get 'following', on: :collection
      end
      resources :notices, only: [:index] do
        get 'check', on: :collection
      end
      member do
        post '/follow', to: 'relationships#create'
        delete '/unfollow', to: 'relationships#destroy'
        patch '/update_avatar', to: 'users#update_avatar'
      end
      collection do
        get '/experience_rank', to: 'users#experience_rank'
        get '/search', to: 'users#search'
      end
    end
    resources :tags, only: [:show] do
      post :follow, on: :member
      delete :unfollow, on: :member
      get :search, on: :collection
    end
    resources :time_reports, except: [:new, :edit] do
      resources :comments, only: [:index]
      get :tag_search, on: :collection
    end
    resources :comments, only: [:create, :destroy]
    resource :like, only: [:create] do
      delete :delete, on: :collection
    end
    resources :contacts, only: [:create]
    get '/timeline', to: 'feeds#timeline'
    get '/tag_feed', to: 'feeds#tag_feed'
  end

  namespace :v2 do
    resources :users, only: [:index, :show, :create, :update, :edit] do
      member do
        get '/avatar_url', to: 'users#avatar_url'
        get '/following_count', to: 'users#following_count'
        get '/follower_count', to: 'users#follower_count'
      end
      resources :time_reports, only: :index
      resource :experience, only: :show
      resources :weekly_targets, only: [:index, :create]
      resource :weekly_target, only: :show
      resources :likes, only: :index
    end
    resource :required_exp, only: :show
    resources :time_reports, only: [:index, :show, :create, :update, :destroy]
    resource :likes, only: [] do
      post '/delete', to: 'likes#delete'
    end
  end
end
