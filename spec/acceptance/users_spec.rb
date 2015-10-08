require 'spec_helper_acceptance'

create_pp = <<-EOS
class { 'users':
  hash => {
    bob => {
      'ensure'          => 'present',
      'uid'             => 12345,
      'gid'             => 12345,
      'groups'          => ['admin', 'dev'],
      'home'            => '/home/bobers',
      'shell'           => '/bin/bash',
      'packages'        => ['tmux', 'less'],
      'authorized_keys' => {
        'test@localhost' => {
          'type' => 'rsa',
          'key'  => 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        },
      },
      'ssh_key_pair'    => {
        'test' => {
          'private_content' => 'Private content',
          'public_content'  => 'Public content',
        },
      },
      'config_files'    => {
        '/home/bobers/.tmuxrc' => {
          'content' => 'set-window-option -g xterm-keys on',
        },
      },
    },
  },
}
EOS

remove_pp = <<-EOS
class { 'users':
  hash => {
    bob => {
      'ensure' => 'absent',
    },
  },
}
EOS

describe 'users', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  it 'creating should run without errors' do
    apply_manifest(create_pp, :catch_failures => true)
  end

  it 'creating should be idempotent' do
    apply_manifest(create_pp, :catch_changes => true)
  end

  it 'should create user bob correctly' do
    shell("/usr/bin/id bob") do |r|
      expect(r.stdout).to match(/uid=12345\(bob\)/)
      expect(r.stdout).to match(/gid=12345\(bob\)/)
      expect(r.stdout).to match(/admin/)
      expect(r.stdout).to match(/dev/)
    end

    shell("grep 'bob' /etc/passwd") do |r|
      expect(r.stdout).to match(
        /bob:.*:12345:12345:.*:\/home\/bobers:\/bin\/bash/
      )
    end
  end

  it 'should setup home directory with correct permissions' do
    shell("ls -lhd /home/bobers") do |r|
      expect(r.stdout).to match(/^drwxr-xr-x.*bob bob.*\/home\/bobers$/)
    end
  end

  it 'should setup expected authorized key' do
    shell("cat /home/bobers/.ssh/authorized_keys") do |r|
      expect(r.stdout).to match(/ssh-rsa ABCDEFGHIJKLMNOPQRSTUVWXYZ test@localhost$/)
    end
  end

  it 'should setup expected ssh key pair' do
    shell("cat /home/bobers/.ssh/test") do |r|
      expect(r.stdout).to match(/Private content/)
    end

    shell("cat /home/bobers/.ssh/test.pub") do |r|
      expect(r.stdout).to match(/Public content/)
    end
  end

  it 'should create expected config file' do
    shell("ls -lh /home/bobers/.tmuxrc; cat /home/bobers/.tmuxrc") do |r|
      expect(r.stdout).to match(/set-window-option -g xterm-keys on/)
    end
  end

  it 'should install expected packages' do
    shell("which tmux") do |r|
      expect(r.stdout).to match(/tmux/)
    end

    shell("which less") do |r|
      expect(r.stdout).to match(/less/)
    end
  end

  it 'removing should run without errors' do
    apply_manifest(remove_pp, :catch_failures => true)
  end

  it 'removing should be idempotent' do
    apply_manifest(remove_pp, :catch_changes => true)
  end

  it 'should remove user bob' do
    shell("/usr/bin/id bob", :acceptable_exit_codes => [1]) do |r|
      expect(r.stderr).to match(/[nN]o such user/)
    end
  end
end
