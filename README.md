# users

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What users affects](#what-users-affects)
    * [Beginning with users](#beginning-with-users)
3. [Usage](#usage)
4. [Reference](#reference)
    * [Classes](#classes)
    * [Defined Types](#defined-types)
4. [Limitations](#limitations)
5. [Development](#development)

## Module Description

This module offers comprehensive user management.  It is designed to provide a single interface for common user management tasks.  So far this includes:

* SSH authorized key management.
* SSH public and private key management.
* User specific configuration file management.
* User related packages installation.

The module is designed with the flexibility to define users in multiple ways:

* Individually, by defining `users:account` resources.
* Collectively, by passing all users and settings as a hash.  This can be accomplish in multiple ways:
    * Simply passing the users hash to the main `users` class will immediately instantiate the users accounts.
    * Passing the users hash to the `users::virtual` class will create virtual users accounts that can then be realized in other parts of your project.
    * Defining the users hash (either virtually or not) in Hiera.

## Setup

### What users affects

* System user management files and directories.
* User home directories and files.
 * Specifically user SSH directories and files.

### Beginning with users

To use the added functionality of the module at its minimum something like this will get you started:

```puppet
users::account { 'bob':
  ssh_key_pair         => {
    'test-rsa' => {
      key_name        => 'rsa',
      public_content  => 'Public_key_content',
      private_content => 'Private_key_content',
    },
  },
}
```

## Usage

### Create multiple users

If you want to create multiple user accounts, you can supply a hash with all the values:

```puppet
class { 'users':
  hash => {
    'bob'   => { 'ensure' => 'present' },
    'sandy' => { 'ensure' => 'present' },
  }
}
```

This can also be done with hiera by adding the following to file in your hiera hierarchy:

```yaml
users::hash:
  bob:
    ensure: present
  sandy:
    ensure: present
```

Once you have your user data setup in hiera, all that is needed is to include the users class.

```puppet
class { 'users': }
```


### Create multiple virtual users

Creating virtual users allows you define users once for an entire project.

```puppet
class { 'users::virtual':
  hash => {
    'bob'   => { 'ensure' => 'present' },
    'sandy' => { 'ensure' => 'present' },
  }
}
```

Or again if you want to do this hiera:

```yaml
users::virtual::hash:
  bob:
    ensure: present
  sandy:
    ensure: present
```

Once your virtual users are setup all you need to do is realize them wherever the project requires them:

```puppet
realize( Users:Account['sandy'] )
```

## Reference

### Classes

#### users

Creates all the specified user accounts using the `users::account` resource.

##### `hash`

Hash of all user accounts. Each user should be a key and all corresponding account values are the associated hash value.

#### users::virtual

Defines all the specified virtual user accounts using the `users::acount` resource.

##### `hash`

Hash of all virtual user accounts. Each virtual user should be a key and all corresponding account values are the associated hash value.

### Defined Types

#### users::account

Creates a customized user account that expands upon the built-in puppet `user` type.

##### `ensure`

   The state that the account should be in. 

   Valid values are `present` and `absent`.

##### `allowdupe`

   Value passed to the puppet built-in user type.

   The default value is `false`.

##### `attribute_membership`

   Value passed to the puppet built-in user type.

   The default value is `'minimum'`.

##### `attributes`

   Value passed to the puppet built-in user type.

##### `auth_membership`

   Value passed to the puppet built-in user type.

   The default value is `'minimum'`.

##### `auths`

   Value passed to the puppet built-in user type.

##### `comment`

   Value passed to the puppet built-in user type.

##### `expiry`

   Value passed to the puppet built-in user type.

##### `forcelocal`

   Value passed to the puppet built-in user type.

##### `gid`

   Value passed to the puppet built-in user type.

##### `groups`

   Value passed to the puppet built-in user type.

##### `home`

   Value passed to the puppet built-in user type.

   The default value is `"/home/${name}"`.

##### `ia_load_module`

   Value passed to the puppet built-in user type.

##### `iterations`

   Value passed to the puppet built-in user type.

##### `key_membership`

   Value passed to the puppet built-in user type.

##### `keys`

   Value passed to the puppet built-in user type.

##### `managehome`

   Value passed to the puppet built-in user type.

   The default value is `true` unlike the default for the user type.

##### `membership`

   Value passed to the puppet built-in user type.

   The default value is `'minimum'`.

##### `password`

   Value passed to the puppet built-in user type.

##### `password_max_age`

   Value passed to the puppet built-in user type.

##### `password_min_age`

   Value passed to the puppet built-in user type.

##### `profile_membership`

   Value passed to the puppet built-in user type.

   The default value is `'minimum'`.

##### `profiles`

   Value passed to the puppet built-in user type.

##### `project`

   Value passed to the puppet built-in user type.

##### `provider`

   Value passed to the puppet built-in user type.

##### `purge_ssh_keys`

   Value passed to the puppet built-in user type.

   The default value is `false`.

##### `role_membership`

   Value passed to the puppet built-in user type.

   The default value is `'minimum'`.

##### `roles`

   Value passed to the puppet built-in user type.

##### `salt`

   Value passed to the puppet built-in user type.

##### `shell`

   Value passed to the puppet built-in user type.

##### `system`

   Value passed to the puppet built-in user type.

   The default value is `false`.

##### `uid`

   UID of the user the account creates.

##### `authorized_keys`

   Hash of all the SSH keys that user account will accept connections for.

##### `ssh_key_pair`

   Hash of all the public and private ssh pairs to create and manage.

##### `config_files`

   Hash of all the account config files to create and manage.

##### `packages`

  Array of all user needed packages to ensure are installed.


#### users::ssh\_key\_pair

Creates SSH keys for authentication.

##### `user`

 The existing user account in which the SSH key pair will be installed.  The user will be autorequired if managed by a `user` resource.

##### `home`

 Home directory of the `user` where the .ssh directory for the SSH key pair to be installed in exists.

 Default value is `'/home/$user'`.

##### `key_name`

 (*Namevar*: If omitted, the value of this attribute defaults to the resource's title)

 Base name of the key pair.  The private key will have this name and the public key will have a suffix of .pub appended to this.

##### `ensure`

 Set the state of the key pair on the system.

 Default value is `present`.

##### `group`

 Group that will own of the key pair files.

##### `private_source`

 The puppet URI locating the private ssh key file. This cannot be defined along with `private_content`.

##### `private_content`

 The contents of the private ssh key file. This cannot be defined along with `private_source`.

##### `public_source`

 The puppet URI locating the public ssh key file. This cannot be defined along with `public_content`.

##### `public_content`

 The contents of the public ssh key file. This cannot be defined along with `public_source`.

## Limitations

This module currently only receives testing on the following operating systems:

* Debian (5,6,7)
* Ubuntu (12.04,14.04)
* CentOS (5,6,7)

This module will likely work on many other Linux distributions, but no grantees are made.

## Development

See [CONTRIBUTING.md](https://github.com/MrAlias/users/blob/master/CONTRIBUTING.md)
