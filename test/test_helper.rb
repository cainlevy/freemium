ENV["RAILS_ENV"] = "test"

# load the support libraries
require 'test/unit'
require 'rubygems'
require 'active_record'
require 'active_record/fixtures'
require 'action_mailer'
require 'mocha'

# establish the database connection
ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + '/db/database.yml'))
ActiveRecord::Base.establish_connection('active_record_merge_test')

# capture the logging
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")

# load the schema
$stdout = File.open('/dev/null', 'w')
load(File.dirname(__FILE__) + "/db/schema.rb")
$stdout = STDOUT

# load the ActiveRecord models
require File.dirname(__FILE__) + '/db/models'

# configure the TestCase settings
class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  self.fixture_path = File.dirname(__FILE__) + '/fixtures/'
end

# disable actual email delivery
ActionMailer::Base.delivery_method = :test

# load the code-to-be-tested
$LOAD_PATH.push File.dirname(__FILE__) + '/../lib'
require File.dirname(__FILE__) + '/../init'
