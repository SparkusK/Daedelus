class ChangeConstraintsOnOrders < ActiveRecord::Migration[5.1]

  def up
    execute %{
      ALTER TABLE
        debtor_orders
      DROP CONSTRAINT
        value_incl_lt_value_excl;

      ALTER TABLE
        debtor_orders
      ADD CONSTRAINT
        value_excl_lt_value_incl
      CHECK( value_excluding_tax < value_including_tax );

      ALTER TABLE
        creditor_orders
      DROP CONSTRAINT
        value_incl_lt_value_excl;

      ALTER TABLE
        creditor_orders
      ADD CONSTRAINT
        value_excl_lt_value_incl
      CHECK( value_excluding_tax < value_including_tax );
    }
  end

  def down
    execute %{
      ALTER TABLE
        debtor_orders
      DROP CONSTRAINT
        value_excl_lt_value_incl;

      ALTER TABLE
        debtor_orders
      ADD CONSTRAINT
        value_incl_lt_value_excl
      CHECK( value_excluding_tax < value_including_tax );

      ALTER TABLE
        creditor_orders
      DROP CONSTRAINT
        value_excl_lt_value_incl;

      ALTER TABLE
        creditor_orders
      ADD CONSTRAINT
        value_incl_lt_value_excl
      CHECK( value_excluding_tax < value_including_tax );
    }
  end

end
