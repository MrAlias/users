require 'beaker-rspec'


UNSUPPORTED_PLATFORMS = []

hosts.each do |host|
  create_remote_file host, '/etc/locale.gen', 'en_US.UTF-8 UTF-8'
  shell 'locale-gen'
  host.add_env_var('LANG', 'en_US.UTF-8')
  host.add_env_var('LANGUAGE', 'en_US.UTF-8')
  host.add_env_var('LC_ALL', 'en_US.UTF-8')

  on host, install_puppet
  on host, puppet('module install puppetlabs-stdlib -v 4.5.1')
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
