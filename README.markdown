# puppet-perl
=============

This module installs the Perl programming language package, and provides a definition for loading and excluding Perl modules available on CPAN.

* http://www.perl.org/
* http://www.cpan.org/

Note: Perl modules are hightly variable in their implementation, because "there's more than one way to do it", so some modules will have to be installed some other way. Though this module should give some idea on suitable code patterns that could get it done.

# To install into puppet

Clone into your puppet configuration in your `puppet/modules` directory:

 git clone git://github.com/nesi/puppet-perl.git perl

Or if you're managing your Puppet configuration with git, in your `puppet` directory:

		git submodule add git://github.com/nesi/puppet-perl.git modules/perl --init --recursive
		cd modules/perl
		git checkout master
		git pull
		cd ../..
		git commit -m "added perl submodule from https://github.com/nesi/puppet-perl"

It might seem bit excessive, but it will make sure the submodule isn't headless...

# Requirements

Only tested on Ubuntu 12.04 LTS, should work for other Debian distributions. Should not require any other packages installed.

# Using the `perl` class
========================

The `perl` class ensures that the Perl language is installed with some minimal tools required to manage Perl and CPAN modules.

## Default Perl install

This should install the `perl`, `pm-tools` and the `Apps::pmuninstall` module with the default settings.

    include perl

I reccomend you at _least_ specify a CPAN mirror.

## Installing with parameters

		class{'perl':
				version 			=> '5.8.6',
				ensure				=> installed,
				cpan_mirror		=> 'ftp://some.mirror.cpan.org/pub/perl/CPAN/',
		}

## Parameters

* **version**: Specifies the Perl version to install, defaults to the default installed on your Linux distribution.
*	**ensure**:	Passed to the packages installed, 'installed' is default.
*	**cpan_mirror**:	Select your CPAN mirrod, ftp://ftp.auckland.ac.nz/pub/perl/CPAN/ is the default. Change this if you're not in New Zealand.
*	**package**: Specifies the Package to be installed, the defaultis 'perl'
*	**pmtools_package**: Specifies the Perl management tools package to be installed, defaults to 'pmtools'.

# Using the `perl::cpan` resource definition
============================================

Install a Perl module from CPAN:

    perl::cpan{'module::name': ensure => installed}

Ensure that a Perl module is not installed:

    perl::cpan{'module::name': ensure => absent}

## Parameters

* **ensure**: Ensure that the module is 'installed' or 'absent', defaults to installed.
* **timeout**: Changes the timeout in seconds for installing the Perl module, some modules can take a quite some time to compile. By default it is set to 120 seconds.

# To do...
==========

* Change the CPAN definition to a case format for handling exceptional packages, broken package, and obsolete packages.
* Create some facter scripts for Perl, such as getting version and reporting CPAN mirror

# Credits
=========

Written by Aaron Hicks (hicksa@landcareresearch.co.nz) for the New Zealand eScience Infrastructure.

<a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/"><img alt="Creative Commons Licence" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/3.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/">Creative Commons Attribution-ShareAlike 3.0 Unported License</a>