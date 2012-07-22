define perl::cpan(
	$ensure 	= 'installed'
){
	if $ensure == installed {
	  exec{"cpan_load_${name}":
	  	path 		=> ['/usr/bin/','/bin'],
	   	command => "cpan -i ${name}",
	   	unless 	=> "perl -M${name} -e 'print \"${name} loaded\"'",
	   	timeout => 600,
	   	require => [Package[$perl::package],Exec['configure_cpan']],
	  }
	} elsif $ensure == absent {
		if $name != "App::pmuninstall"{
			exec{"cpan_unload_${name}":
		  	path 		=> ['/usr/bin/','/bin','/usr/local/bin'],
		   	command => "pm-uninstall ${name}",
		   	onlyif 	=> "perl -M${name} -e 'print 1' 2>/dev/null",
		   	timeout => 600,
		   	require => [Package[$perl::package],Exec['configure_cpan','install_pmuninstall']],
		  }
		} else {
			warning("App::pmuninstall is required, and will not be uninstalled on ${fqdn}")
		}
	}
}