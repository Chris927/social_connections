guard 'rspec', :cli => "--color", :version => 2, :all_on_start => true, :all_after_pass => true do
  watch %r{^spec/.+_spec\.rb$}
  watch(%r{^lib/.+\.rb$}) { "spec" }

end
