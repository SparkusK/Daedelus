Rails.application.routes.draw do

  resources :summaries, only: [:new, :show]
  resources :credit_notes
  resources :creditor_orders
  resources :debtor_payments
  resources :debtor_orders
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

  get '/summaries', to: "summaries#new"
  get '/summaries/new', to: "summaries#new"
  post 'summaries/new', to: "summaries#show"

end
