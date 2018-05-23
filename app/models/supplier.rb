class Supplier < ApplicationRecord
  def supplier_name
    "#{name}"
  end

  # Search by name, email, or phone
  def fuzzy_search(params)
    # if params contains numbers
      # search phone
    # else
      # search the rest
    # end
  end
end
