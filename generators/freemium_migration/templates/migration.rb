class CreateSubscriptionAndPlan < ActiveRecord::Migration
  def self.up
    create_table :subscription_plans, :force => true do |t|
      t.column :name, :string, :null => false
      t.column :rate_cents, :integer, :null => false
      t.column :yearly, :boolean, :null => false
    end

    create_table :subscriptions, :force => true do |t|
      t.column :subscribable_id, :integer, :null => false
      t.column :subscribable_type, :string, :null => false
      t.column :subscription_plan_id, :integer, :null => false
      t.column :paid_through, :date, :null => false
      t.column :expire_on, :date, :null => true
      t.column :billing_key, :string, :null => true
      t.column :last_transaction_at, :datetime, :null => true
    end

    # for polymorphic association queries
    add_index :subscriptions, :subscribable_id
    add_index :subscriptions, :subscribable_type

    # for finding due, pastdue, and expiring subscriptions
    add_index :subscriptions, :paid_through
    add_index :subscriptions, :expire_on

    # for applying transactions from automated recurring billing
    add_index :subscriptions, :billing_key
  end

  def self.down
    drop_table :subscription_plans
    drop_table :subscriptions
  end
end
