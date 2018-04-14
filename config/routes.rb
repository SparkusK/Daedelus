Rails.application.routes.draw do

  resources :supervisors
  resources :invoices
  resources :suppliers
  resources :customers
  resources :labor_records
  resources :jobs
  resources :orders
  resources :quotations
  resources :sections
  resources :employees
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "dashboard#index"
end
