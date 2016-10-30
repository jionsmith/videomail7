class AddDurationToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :plan_duration, :integer
    add_index :orders, :plan_duration
    add_index :orders, :payment_method

    Order.update_all plan_duration: 12
    Order.baio.update_all plan_duration: Plan.free_plan_duration
  end
end
