json.extract! credit_note, :id, :creditor_order_id, :payment_type, :amount_paid, :note, :created_at, :updated_at
json.url credit_note_url(credit_note, format: :json)
