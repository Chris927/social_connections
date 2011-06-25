namespace :db do
  namespace :migrate do
    description = "migrate the db in vendor/plugins/social_connections/lib/db/migrate"

    desc description
    task :social_connections => :environment do
      ActiveRecord::Migration.verbose = true
      ActiveRecord::Migrator.migrate(File.join(File.dirname(__FILE__), '../db/migrate/'), ENV['VERSION'] ? ENV['VERSION'].to_i : nil)
      Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
    end
  end
end
