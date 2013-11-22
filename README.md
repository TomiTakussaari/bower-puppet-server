bower-puppet-server
===================

Puppet module for configuring puppet server using [Bower](http://bower.io) for providing environments from git repositories

#### See [Bower-puppet-master-example](https://github.com/TomiTakussaari/bower-puppet-master-example)

### Features
- Configure [Puppet environments](http://docs.puppetlabs.com/guides/environment.html) using [Bower](http://bower.io/) and Git
- Configures itself (Using Puppet of course)
- HTTP API for doing nice things

### Why ?
- Makes you create releases from your Puppet Environments
- No need for Git triggers
- Because it was possible

### Usage

		class { "bower_puppet_server":
        	environments => template("my_module/my_environments")
        }

* It expects environments to contain string in following format:

		"MY_ENVIRONMENT": "GIT_READ_ONLY_URL#GIT_TAG",
		"MY_OTHER_ENVIRONMENT": "GIT_READ_ONLY_URL#GIT_TAG",

* GIT_READ_ONLY_URL#1 means "always use latest 1.x.x release from GIT_READ_ONLY_URL repository"
* It uses [Bower](http://bower.io/), so other tricks work too!
* Environment names may contain only alphanumeric characters and underscores (like foo_bar1)

#### HTTP API
* List environments and tracked releases

        curl PUPPET_SERVER:8080/environments

* Force environment update (If time is money and you cannot afford to wait for it to happen automatically after 1 minute)

        curl -X POST PUPPET_SERVER:8080/environments

* Show version of environment

        curl http://PUPPET_SERVER:8080/environments/MY_ENVIRONMENT

* List servers managed with this Puppet Server

        curl http://PUPPET_SERVER:8080/servers

* How it works ? See [bowerpuppet-api](files/opt/puppet/bowerpuppet-api/)
