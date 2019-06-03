json.extract! debtor_payment, :id, :debtor_order_id, :payment_amount, :payment_date, :payment_type, :note, :created_at, :updated_at
json.url debtor_payment_url(debtor_payment, format: :json)
