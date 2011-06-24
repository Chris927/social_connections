# SocialConnections

require 'social_connections/acts_as_connectable'
require 'social_connections/social_aggregator'

%w{ models mailers }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.autoload_paths << path
  ActiveSupport::Dependencies.autoload_once_paths.delete(path)
end

