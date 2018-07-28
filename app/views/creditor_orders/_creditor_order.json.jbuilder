json.extract! creditor_order, :id, :supplier_id, :job_id, :delivery_note, :date_issued, :value_excluding_tax, :tax_amount, :value_including_tax, :still_owed_amount, :created_at, :updated_at
json.url creditor_order_url(creditor_order, format: :json)
