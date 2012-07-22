# This should be ensurable, but there's not point until
# a 'remove' script is figured ot for 'absent'

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
	# } elsif $ensure == absent {
	# 	exec{"cpan_load_${name}":
	#   	path 		=> ['/usr/bin/','/bin'],
	#    	command => "cpan -i ${name}",
	#    	unless 	=> "perl -M${name} -e 'print 1' 2>/dev/null",
	#    	timeout => 600,
	#    	require => [Package[$perl::package],Exec['configure_cpan']],
	#   }
	}
}