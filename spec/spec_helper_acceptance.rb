#!/usr/bin/env ruby -S rspec

require 'beaker-rspec'


UNSUPPORTED_PLATFORMS = []

hosts.each do |host|
  on host, install_puppet
end


RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  module_name = module_root.split(File::SEPARATOR).last

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    puppet_module_install(:source => module_root, :module_name => module_name)

    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs/stdlib'), { :acceptable_exit_codes => [0] }
    end
  end
end
