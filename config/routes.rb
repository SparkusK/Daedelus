Rails.application.routes.draw do

  resources :job_targets
  resources :managers
  resources :summaries, only: [:new, :show]
  resources :credit_notes
  resources :creditor_orders
  resources :debtor_payments
  resources :debtor_orders
  resources :supervisors
  resources :suppliers
  resources :customers
  resources :labor_records
  resources :jobs
  resources :orders
  resources :sections
  resources :employees, only: [:index, :new, :edit, :create, :update, :destroy]
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "dashboard#index"

  get '/summaries', to: "summaries#new"
  get '/summaries/new', to: "summaries#new"
  post 'summaries/new', to: "summaries#show"

  get '/payroll', to: "payrolls#index"

  get '/employees/:id', to: "employees#cancel", as: :cancel_employee

  get '/employees/:id/rates', to: "employees#ajax_rates"
  get '/debtor_orders/:id/amounts', to: "debtor_orders#ajax_amounts"

end


# There is an exception for the format constraint:
# while it's a method on the Request object, it's
# also an implicit optional parameter on every path.
# Segment constraints take precedence and the format
# constraint is only applied as such when enforced
# through a hash. For example,
#   get 'foo', constraints: { format: 'json' }
# will match GET  /foo because the format is optional
# by default. However, you can use a lambda like in
#   get 'foo', constraints: lambda { |req| req.format == :json }
# and the route will only match explicit JSON requests.
#
# https://guides.rubyonrails.org/routing.html
