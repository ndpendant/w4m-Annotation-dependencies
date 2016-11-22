#!perl

## script  : XXX.pl
#=============================================================================
#                              Included modules and versions
#=============================================================================
## Perl modules
use strict ;
use warnings ;
use Carp qw (cluck croak carp) ;

use Data::Dumper ;
use Getopt::Long ;
use FindBin ; ## Allows you to locate the directory of original perl script

## Specific Perl Modules (PFEM)
use lib $FindBin::Bin ;

## Dedicate Perl Modules (Home made...)
#use lib '\\\\nas-theix\\fgiacomoni\\BioInfoTools\\PFEM\\template' ;
use _module qw( :ALL ) ;

## Initialized values
my $OptHelp ;

#=============================================================================
#                                Manage EXCEPTIONS
#=============================================================================
&GetOptions ( 	"h"     => \$OptHelp,       # HELP
            ) ;
         
## if you put the option -help or -h function help is started
if ( defined($OptHelp) ){ &help ; }

#=============================================================================
#                                MAIN SCRIPT
#=============================================================================





#====================================================================================
# Help subroutine called with -h option
# number of arguments : 0
# Argument(s)        :
# Return           : 1
#====================================================================================
sub help {
	print STDERR "
XXX.pl

# XXX is a script to ...
# Input : 
# Author : Franck Giacomoni and Marion Landi
# Email : fgiacomoni\@clermont.inra.fr or mlandi\@clermont.inra.fr
# Version : 1.0
# Created : xx/xx/201x
USAGE :		 
		XXX.pl -options
		
		";
	exit(1);
}

## END of script - F Giacomoni 

__END__

=head1 NAME

 XXX.pl -- script for

=head1 USAGE

 XXX.pl -precursors -arg1 [-arg2] 
 or XXX.pl -help

=head1 SYNOPSIS

This script manage ... 

=head1 DESCRIPTION

This main program is a ...

=over 4

=item B<function01>

=item B<function02>

=back

=head1 AUTHOR

Franck Giacomoni E<lt>franck.giacomoni@clermont.inra.frE<gt>
Marion Landi E<lt>marion.landi@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : xx / xx / 201x

version 2 : ??

=cut