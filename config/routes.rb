Rails.application.routes.draw do
  namespace :v1 do
    resources :users, only: [ :index, :show, :create ]
    resources :time_report, only: [ :index, :create, :edit, :destroy ]
  end
end
