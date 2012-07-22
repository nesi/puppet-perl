# This should be ensurable, but there's not point until
# a 'remove' script is figured ot for 'absent'

define perl::cpan(

){
  exec{"cpan_load_${name}":
  	path 		=> ['/usr/bin/','/bin'],
   	command => "perl -MCPAN -e '\$ENV{PERL_MM_USE_DEFAULT}=1; CPAN::Shell->install(\"${name}\")'",
   	onlyif 	=> "test `perl -M${name} -e 'print 1' 2>/dev/null || echo 0` == '0'",
   	require => [Package[$perl::package],Exec['configure_cpan']],
  }
}