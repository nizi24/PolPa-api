Rails.application.routes.draw do
  namespace :v1 do
    resources :users, only: [ :index, :show, :create ]
    resources :time_reports, except: [ :new, :edit ]
    resources :comments, only: [ :create, :destroy ]
  end
end
