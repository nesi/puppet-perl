# An installer manifest for perl,
# It's not complicated but required to 'standardise' the Perl install
# and make some variables accessible to other parts of this module
#
# The default CPAN mirror is in New Zealand, so choose a more suitabled one
# from http://www.cpan.org/SITES.html

class perl (
	$version 			= false,
	$ensure				= installed,
	$cpan_mirror	= 'ftp://ftp.auckland.ac.nz/pub/perl/CPAN/'
){

	$package = 'perl'
	$pmtools_package = 'pmtools'

	if $version == false {
		package{$package:
			ensure => $ensure,
		}
		package{$pmtools_package:
			ensure => $ensure,
		}
	} else {
		package{$package:
			ensure 	=> $ensure,
			version => $version
		}
		package{$pmtools_package:
			ensure => $ensure,
		}
	}

	exec{'configure_cpan':
		command	=> "/usr/bin/cpan <<EOF
yes	
yes
no
no
${cpan_mirror}

yes
quit
EOF",
		creates => "/root/.cpan/CPAN/MyConfig.pm",
		require => Package[$package],
		timeout => 600,
	}

  exec{"install_pmuninstall":
  	path 		=> ['/usr/bin/','/bin'],
   	command => "cpan -i App::pmuninstall",
   	unless 	=> "perl -MApp::pmuninstall -e 'print \"App::pmuninstall loaded\"'",
   	timeout => 600,
   	require => [Package[$perl::package],Exec['configure_cpan']],
  }
}