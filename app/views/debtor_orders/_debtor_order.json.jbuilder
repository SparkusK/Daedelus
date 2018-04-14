json.extract! debtor_order, :id, :customer_id, :job_id, :invoice_id, :SA_number, :value_including_tax, :tax_amount, :value_excluding_tax, :still_owed_amount, :created_at, :updated_at
json.url debtor_order_url(debtor_order, format: :json)
