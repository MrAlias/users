# == Class: users::virtual
#
# Create and manaage virtual user accounts.
#
# This provides a consitent way to create virtual user accounts which can
# then be realized anywhere else in a project, maintaining a consitent
# collection of user values.
#
# === Parameters
#
# [*hash*]
#   Hash of all virtual user accounts. Each virtual user should be a key and
#   all corresponding account values are the associated hash value.
#
# === Examples
#
#  For a basic virtual user setup creating the bob user:
#
#    class { 'users::virtual':
#      hash    => {
#        'bob' =>  { 'ensure' => 'present', 'uid' => '10001' },
#      }
#    }
#
#  Another way to setup the virtual bob user using hiera would be to have
#  something like this in a hiera hierarcy file:
#
#    ...
#    users::virtual::hash:
#      bob:
#        ensure: present
#        uid: 10001
#    ...
#  
#  and then including the class with hiera or in a manifest:
#
#  class { 'users::virtual': }
#
# === Authors
#
# Tyler Yahn <codingalias@gmail.com>
#
class users::virtual (
  $hash = hiera_hash("${module_name}::virtual::hash", {}),
) {
  validate_hash($hash)
  create_resources("@${module_name}::account", $hash)
}

