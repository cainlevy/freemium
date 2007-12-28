require File.dirname(__FILE__) + '/test_helper'

class SubscriptionPlanTest < Test::Unit::TestCase
  fixtures :users, :subscriptions, :subscription_plans

  def test_associations
    assert_equal [subscriptions(:bobs_subscription)], subscription_plans(:basic).subscriptions
  end

  def test_rate_intervals
    plan = SubscriptionPlan.new(:rate_cents => 36500, :yearly => true)
    assert_equal Money.new(100), plan.daily_rate
    assert_equal Money.new(3041), plan.monthly_rate
    assert_equal Money.new(36500), plan.yearly_rate

    plan = SubscriptionPlan.new(:rate_cents => 3041, :yearly => false)
    assert_equal Money.new(99), plan.daily_rate
    assert_equal Money.new(3041), plan.monthly_rate
    assert_equal Money.new(36492), plan.yearly_rate
  end

  def test_creating_plan
    plan = create_plan
    assert !plan.new_record?, plan.errors.full_messages.to_sentence
  end

  def test_missing_fields
    [:name, :rate_cents].each do |field|
      plan = create_plan(field => nil)
      assert plan.new_record?
      assert plan.errors.on(field)
    end
  end

  protected

  def create_plan(options = {})
    SubscriptionPlan.create({
      :name => 'super-duper-ultra-premium',
      :rate_cents => 99995,
      :yearly => false
    }.merge(options))
  end
end