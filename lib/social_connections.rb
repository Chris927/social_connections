# SocialConnections

require 'social_connections/acts_as_connectable'
require 'social_connections/social_aggregator'

unless ENV['TEST'] == 'TRUE'
  class SocialConnectionsTasks < Rails::Railtie
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'tasks/*.rake')].each { |f| load f }
    end
  end
end

%w{ models mailers }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.autoload_paths << path
  ActiveSupport::Dependencies.autoload_once_paths.delete(path)
end

unless ENV['TEST'] == 'TRUE'
  module SocialConnections
    class Engine < Rails::Engine
      paths["app/views"] = "lib/app/views"
    end
  end
end

path = File.join(File.dirname(__FILE__), 'tasks')
ActiveSupport::Dependencies.autoload_paths << path
