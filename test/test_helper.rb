
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'
ENV['TEST'] = 'TRUE'

require 'rubygems'
require 'test/unit'
require 'active_support'
require 'active_support/core_ext'
require 'active_record'
require 'action_mailer'

require File.dirname(__FILE__) + '/../init'

class Connectable < ActiveRecord::Base
  acts_as_connectable :verbs => [ :likes, :recommends, :comments, :follows ]
  def to_s
    "Connectable '#{self.name}'"
  end
end

def load_schema
  config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
  ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")

  db_adapter = ENV['DB']

  # no db passed, try one of these fine config-free DBs before bombing.
  db_adapter ||=
    begin
      require 'rubygems'
      require 'sqlite'
      'sqlite'
    rescue MissingSourceFile
      begin
        require 'sqlite3'
        'sqlite3'
      rescue MissingSourceFile
      end
    end

  if db_adapter.nil?
    raise "No DB Adapter selected. Pass the DB= option to pick one, or install Sqlite or Sqlite3."
  end

  # helper needed here only
  def capture_stdout &block
    real_out, $stdout = $stdout, StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = real_out
  end

  capture_stdout do # we ignore stdout for this, it pollutes the output
    ActiveRecord::Base.establish_connection(config[db_adapter])
    load(File.dirname(__FILE__) + "/schema.rb")
  end

end

load_schema

ActionMailer::Base.delivery_method = :file
ActionMailer::Base.file_settings = { :location => 'tmp/mails' }
ActionMailer::Base.raise_delivery_errors = true
