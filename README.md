# users

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What users affects](#what-users-affects)
    * [Beginning with users](#beginning-with-users)
4. [Usage](#usage)
5. [Reference](#reference)
    * [Classes](#classes)
    * [Defined Types](#defined-types)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Puppet module that handles user account management with support for virtual users and hiera.

## Module Description

This module is intended to be an addition to the puppet built-in user type:

* It adds features to better support management of normal users in addition to system users by implementing an account class.
* Support is provided to handle virtual user declaration, helping to keep all users across you puppet project in a consistent and easily realizable state.
* Both declaration of data by a traditional manifest as well as via hiera are both supported.

## Setup

### What users affects

* System user management files and directories.
* User home directories and files.
 * Specifically user SSH directories and files.

### Beginning with users

To use the added functionality of the module at its minimum something like this will get you started:

```
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
class { 'users::virtual':
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

```
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

* `users`: Creates all the specified user accounts using the `users::account` resource.
* `users::virtual`: Defines all the specified virtual user accounts using the `users::acount` resource.

### Defined Types

* `users::account`: Creates a customized user account that expands upon the built-in puppet `user` type.
* `users::ssh_key_pair`: Creates SSH keys for authentication.

## Limitations

So far this module has only been tested on Debian based systems.

That's not to say that it won't work on others, but until the project matures and is tested on multiple platforms no guarantees are made.
