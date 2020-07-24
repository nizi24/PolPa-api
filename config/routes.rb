Rails.application.routes.draw do
  namespace :v1 do
    resources :users, only: [:index, :show, :create, :update, :edit] do
      resource :setting, only: [:edit, :update]
      resource :weekly_target, only: [:create]
      resources :tags, only: [] do
        get 'search', on: :collection
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
      end
    end
    resources :time_reports, except: [:new, :edit] do
      resources :comments, only: [:index]
    end
    resources :comments, only: [:create, :destroy]
    resource :like, only: [:create] do
      delete :delete, on: :collection
    end
    get '/timeline', to: 'feeds#timeline'
  end
end
