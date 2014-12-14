#### Puppet Agent Install Script

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with puppet_installer](#setup)
    * [What puppet_installer affects](#what-puppet_installer-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with puppet_installer](#beginning-with-puppet_installer)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Install and run puppet agents on new nodes by doing a `curl puppetmaster.example.com/deploy | bash`.

## Module Description

This module is primarily a wrapper around a shell script that installs Puppet on most common platforms,
then connects back to the puppet master for an initial agent run.

To facilitate that workflow, this module deploys the script, modestly templates it for your puppetmaster
fqdn, then sets up an apache or nginx vhost to host the script.

## Setup

### What puppet_installer affects

* Creates a folder in /etc/puppet/www to store the install script
* Sets up an Apache or Nginx vhost

### Setup Requirements

To do this in a secure way, you really should buy an SSL certificate and use
it instead of piggybacking on your master's SSL cert like it does by default.
You can get a cert for under $10/yr. Bbefore you have the node connected to
the master, you have no way to trust the master's SSL certificate.

Beyond that, typing --insecure on each curl gets old quick.

### Beginning with puppet_installer

At the most basic, you'll need something like:

```puppet
include nginx

class {'::puppet_installer':
  master    => $::fqdn,
  webserver => 'nginx',
  www_root  => '/etc/puppet/www',
  ssl_cert  => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
  ssl_key   => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
}
```

This module is really intended to be used from the [puppetlabs-operations/puppet][puppet-puppet]
module. However, I haven't gotten that PR merged yet, so you'll have to wait
for further instructions.
