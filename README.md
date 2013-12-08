bower-puppet-server
===================

Puppet module for configuring puppet server using [Bower](http://bower.io) for providing environments from git repositories

#### See [Bower-puppet-master-example](https://github.com/TomiTakussaari/bower-puppet-master-example)

### Features
- Configure [Puppet environments](http://docs.puppetlabs.com/guides/environment.html) using [Bower](http://bower.io/) and Git
- Updates environments automatically on background, according to configuration you give it.
- Configures itself by itself (Using Puppet of course)
- HTTP API for doing nice things
- Seems to work on both CentOS 6 & RHEL 6, probably does not work anywhere else currently.

### Why ?
- Forces you to create releases from your Puppet Environments, instead of always deploying "master-SNAPSHOT"
- No need for Git triggers
- Because it was possible

### Usage
* Fetch this module using Bower (install it from [Bower.io](http://bower.io)) 
		
		bower install https://github.com/TomiTakussaari/bower_puppet_server.git#0.5.0

* Or using Puppet

		puppet module install tomitakussaari/bower_puppet_server --version 0.5.0

* Then use it in your own project like this

			class { "bower_puppet_server":
        			environments => template("my_module/my_environments")
        		}

* It expects environments to contain string in following format:

		"MY_ENVIRONMENT": "GIT_READ_ONLY_URL#GIT_TAG",
		"MY_OTHER_ENVIRONMENT": "GIT_READ_ONLY_URL#GIT_TAG",

* GIT_READ_ONLY_URL#1 means "always use latest 1.x.x release from GIT_READ_ONLY_URL repository"
* It uses [Bower](http://bower.io/), so other tricks to choose release work too!
* Environment names may contain only alphanumeric characters and underscores (like foo_bar1)

#### HTTP API
* Fast way to see what versions & environments your installation is providing.
* Enable it:

		class { "bower_puppet_server":
    			environments =>  template("my_module/my_environments"),
    			enable_api=>     'true'
		}

* List environments and tracked releases

        curl PUPPET_SERVER:8080/environments

* Force environment update (If time is money and you cannot afford to wait for it to happen automatically after 1 minute)

        curl -X POST PUPPET_SERVER:8080/environments

* Show version of environment

        curl http://PUPPET_SERVER:8080/environments/MY_ENVIRONMENT

* List servers managed with this Puppet Server

        curl http://PUPPET_SERVER:8080/servers

* How it works ? See [bower-puppet-api](files/opt/puppet/bower-puppet-api/)

License: [MIT](LICENSE)
