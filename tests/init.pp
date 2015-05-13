class { 'users':
  hash  => {
    bob => { 'ensure' => 'present', 'uid' => '10001' },
  },
}
