Rails.application.routes.draw do

  scope module: :data_manipulation do
    resources :job_targets
    resources :managers
    resources :creditor_payments
    resources :creditor_orders
    resources :debtor_payments
    resources :debtor_orders
    resources :suppliers
    resources :customers
    resources :labor_records
    resources :jobs
    resources :sections
    resources :employees

    get '/employees/:id', to: "employees#cancel", as: :cancel_employee

    get '/employees/:id/rates', to: "employees#ajax_rates"
    get '/debtor_orders/:id/amounts', to: "debtor_orders#ajax_amounts"
    get '/creditor_orders/:id/amounts', to: "creditor_orders#ajax_amounts"

    get '/job_targets/:id/amounts/:job_id', to: "job_targets#amounts"
    get '/job_targets/amounts/:job_id', to: "job_targets#amounts_new"

    get 'employees/:id/ajax_labor_dates', to: "employees#ajax_labor_dates"

    get '/labor_records/:employee_id/:labor_date', to: "labor_records#modal_labor_record"
  end
  resources :summaries, only: [:new, :show]
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "dashboard#index"

  get '/summaries', to: "summaries#index"

  get '/payroll', to: "payrolls#index"


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
