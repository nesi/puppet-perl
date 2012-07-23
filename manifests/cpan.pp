# Some CPAN modules should be installed from packages
# especially those with interactive installers
#
# SOAP and DBD::Pg are known to not work

define perl::cpan(
	$ensure 	= 'installed',
	$timeout	= 120
){
	if $ensure == installed {
	  exec{"cpan_load_${name}":
	  	path 		=> ['/usr/bin/','/bin'],
	   	command => "cpan -i ${name}",
	   	unless 	=> "perl -M${name} -e 'print \"${name} loaded\"'",
	   	timeout => $tiemout,
	   	require => [Package[$perl::package],Exec['configure_cpan']],
	  }
	} elsif $ensure == absent {
		if $name != "App::pmuninstall"{
			exec{"cpan_unload_${name}":
		  	path 		=> ['/usr/bin/','/bin','/usr/local/bin'],
		   	command => "pm-uninstall ${name}",
		   	onlyif 	=> "perl -M${name} -e 'print 1' 2>/dev/null",
		   	timeout => $timeout,
		   	require => [Package[$perl::package],Exec['configure_cpan','install_pmuninstall']],
		  }
		} else {
			warning("App::pmuninstall is required, and will not be uninstalled on ${fqdn}")
		}
	}
}