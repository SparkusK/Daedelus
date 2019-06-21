json.extract! creditor_payment, :id, :creditor_order_id, :payment_type, :amount_paid, :note, :created_at, :updated_at
json.url creditor_payment_url(creditor_payment, format: :json)
