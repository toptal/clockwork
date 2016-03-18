rspec_options = {
  cmd: 'bundle exec rspec',
  all_after_pass: true,
  all_on_start: true,
  failed_mode: :focus,
}

guard :rspec, rspec_options do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  watch(%r{app/(.+)\.rb}) do |m|
    "spec/#{m[1]}"
  end

  %w( lib/clockwork/event.rb lib/clockwork/at.rb ).each do |watched|
    watch watched do
      %w(
        spec/clockwork/manager_spec.rb
        spec/clockwork/manager
      )
    end
  end
end
