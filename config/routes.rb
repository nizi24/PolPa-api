Rails.application.routes.draw do
  namespace :v1 do
    resources :users, only: [ :index, :show, :create ]
    resources :time_reports, except: [ :new, :edit ]
    resources :comments, only: [ :create, :destroy ]
    resource :like, only: [ :create ] do
      delete :delete, on: :collection
    end
  end
end
