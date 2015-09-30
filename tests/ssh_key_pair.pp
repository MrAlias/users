user { 'bob': ensure => present, }

file { '/home/bob': ensure => directory, }

users::ssh_key_pair { 'test-dsa':
  ensure          => present,
  user            => 'bob',
  home            => '/home/bob',
  key_name        => 'demo-dsa',
  public_content  => 'Public_key_content',
  private_content => 'Private_key_content',
}
