package date ;

use strict;
use warnings ;
use Exporter ;
use Carp ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw( getDate );
our %EXPORT_TAGS = ( ALL => [qw( getDate)] );

=head1 NAME

date - An module to manage date/time

=head1 SYNOPSIS

    use date;
    my $object = date->new();
    print $object->as_string;

=head1 DESCRIPTION

This module does not really exist, it
was made for the sole purpose of
demonstrating how POD works.

=head1 METHODS

Methods are :

=head2 METHOD new

	## Description : new
	## Input : $self
	## Ouput : bless $self ;
	## Usage : new() ;

=cut

sub new {
    ## Variables
    my $self={};
    bless($self) ;
    return $self ;
}
### END of SUB
     
=head2 METHOD getDate

	## Description : return a formatted date ('week', 'year', 'jjmmaaaa' )
	## Input : $Format
	## Output : $Date
	## Usage : my ( $Date ) = getDate( $Format ) ;
	
=cut
## START of SUB
sub getDate {
	## Retrieve Values
    my $self = shift ;
    my ( $Format ) = @_ ;
    
    my $Date = undef ;
    
    my ( $sec, $min, $hour, $mday, $month, $year, $wday, $yday, $isdst ) = localtime( time ) ;
    
    ## break
    if ( !defined $Format ) { croak "Can't defined the resquested date format\n" ; }
    
	if ( $Format eq 'week') {
		$Date = sprintf ("%02.0f", ($yday/7 ) ) ; 
	}
	elsif ( $Format eq 'year') {
		$Date = 1900+$year ;
	}
    elsif ( $Format eq 'jjmmaaaa') {
		$Date = $mday."/".($month+1)."/".(1900+$year) ;
	}
	elsif ( $Format eq 'mmjjaaaa') {
		$Date = ($month+1)."/".$mday."/".(1900+$year) ;
	}
	elsif ( $Format eq 'STEP' ) {  ## pour les étapes des fichiers log
		$Date = $mday.'/'.($month).'/'.(1900+$year).'>'.($hour).':'.($min).':'.($sec) ; 
	}
	else {
		$Date = undef ;
	}
    return( $Date ) ;
}
## END of SUB

1 ;


__END__

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc date

=head1 Exports

=over 4

=item :ALL getDate

=back

=head1 AUTHOR

Franck Giacomoni E<lt>franck.giacomoni@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : 13 / 02 / 201x

version 2 : ??

=cut