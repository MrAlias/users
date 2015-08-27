class { 'users::virtual':
  hash => {
    bob => {
      'ensure' => 'present',
      'uid'    => '10001'
    },
  },
}

realize(Users::Account['bob'])
