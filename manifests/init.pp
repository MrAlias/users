# == Class: users
#
# Create and manaage user accounts.  This is an instantaneous way to create
# and modify users.
#
# === Parameters
#
# [*hash*]
#   Hash of all user accounts. Each user should be a key and all corresponding
#   account values are the associated hash value.
#
# === Examples
#
#  For a basic user setup creating the bob user:
#
#    class { 'users':
#      hash => {
#        'bob' =>  { 'ensure' => 'present' },
#      }
#    }
#
#  Another way to setup the bob user using hiera would be to have something
#  like this in a hierarcy file:
#
#    ...
#    users::hash:
#      bob:
#        ensure: present
#    ...
#  
#  and then including the class with hiera or in a manifest:
#
#  class { 'users': }
#
# === Authors
#
# Tyler Yahn <codingalias@gmail.com>
#
class users (
  $hash = hiera_hash("${module_name}::hash", {}),
) {
  validate_hash($hash)
  create_resources("${module_name}::account", $hash)
}
