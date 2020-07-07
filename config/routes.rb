Rails.application.routes.draw do
  namespace :v1 do
    resources :users, only: [ :index, :show, :create ]
    resources :time_reports, only: [ :index, :create, :update, :destroy ]
  end
end
