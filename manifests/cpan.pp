# Some CPAN modules should be installed from packages
# especially those with interactive installers
#
# SOAP is known to not work, but it's been unmaintained for a while
# 

define perl::cpan(
	$ensure 	= 'installed',
	$timeout	= 120
){
	if $ensure == installed {
	  exec{"cpan_load_${name}":
	  	path 		=> ['/usr/bin/','/bin'],
	   	command => "cpan -i ${name}",
	   	unless 	=> "pmvers ${name}",
	   	timeout => $timeout,
	   	require => [Package[$perl::package,$perl::pmtools_package],Exec['configure_cpan']],
	  }
	} elsif $ensure == absent {
		if $name != "App::pmuninstall"{
			exec{"cpan_unload_${name}":
		  	path 		=> ['/usr/bin/','/bin','/usr/local/bin'],
		   	command => "pm-uninstall ${name}",
		   	onlyif 	=> "pmvers ${name}",
		   	timeout => $timeout,
		   	require => [Package[$perl::package,$perl::pmtools_package],Exec['configure_cpan','install_pmuninstall']],
		  }
		} else {
			warning("App::pmuninstall is required, and will not be uninstalled on ${fqdn}")
		}
	}
}

# Term::ReadLine::Gnu is special, the module isn't to be included directly.Naughty.
# for it and similar CPAN modules try something like this in your manifest
  # exec{"install_readline_gnu":
  #   path    => ['/usr/bin/','/bin'],
  #   command => "cpan -i Term::ReadLine::Gnu",
  #   # unless  => "perl -MTerm::ReadLine::Gnu -e 'print \"Term::ReadLine::Gnu loaded\"'",
  #   creates => '/usr/local/lib/perl/5.14.2/Term/ReadLine/Gnu.pm',
  #   timeout => 600,
  #   require => [Package[$perl::package],Exec['configure_cpan']],
  # }