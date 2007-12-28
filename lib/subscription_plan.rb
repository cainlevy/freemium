# == Attributes
#   subscriptions:      all subscriptions for the plan
#   rate_cents:         how much this plan costs, in cents
#   rate:               how much this plan costs, in Money
#   yearly:             whether this plan cycles yearly or monthly
#
class SubscriptionPlan < ActiveRecord::Base
  # yes, subscriptions.subscription_plan_id may not be null, but
  # this at least makes the delete not happen if there are any active.
  has_many :subscriptions, :dependent => :nullify

  composed_of :rate, :class_name => 'Money', :mapping => [ %w(rate_cents cents) ], :allow_nil => true

  validates_presence_of :name
  validates_presence_of :rate_cents

  # returns the daily cost of this plan.
  def daily_rate
    yearly_rate / 365
  end

  # returns the yearly cost of this plan.
  def yearly_rate
    yearly? ? rate : rate * 12
  end

  # returns the monthly cost of this plan.
  def monthly_rate
    yearly? ? rate / 12 : rate
  end
end