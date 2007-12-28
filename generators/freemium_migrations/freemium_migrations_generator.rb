class FreemiumMigrationsGenerator < Rails::Generator::NamedBase
  def initialize(runtime_args, runtime_options = {})
    runtime_args.insert(0, 'migrations')
    super
  end

  def manifest
    record do |m|
      m.class_collisions "Subscription", "SubscriptionPlan"
      m.migration_template "migration.erb", "db/migrate", :migration_file_name => "create_subscription_and_plan"
    end
  end
end
