json.extract! invoice, :id, :code, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
