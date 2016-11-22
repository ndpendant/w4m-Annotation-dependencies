package logs::logtools ;

use strict;
use warnings ;
use Exporter ;
use Carp ;

use Data::Dumper ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw(get_duration);
our %EXPORT_TAGS = ( ALL => [qw(get_duration)] );

=head1 NAME

My::Module - An example module

=head1 SYNOPSIS

    use My::Module;
    my $object = My::Module->new();
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


=head2 METHOD get_duration

	## Description : start time at the begin of a script and stop it at its end : get the duration in seconds.
	## Input : $step, $time
	## Output : $time
	## Usage : my ( $time ) = get_( $step, $time ) ;
	
=cut
## START of SUB
sub get_duration {
	## Retrieve Values
    my $self = shift ;
    my ( $step, $time ) = @_ ;
    
	my ( $start_time, $stop_time, $new_time ) = ( 0, 0, 0 ) ;
    
    if ( ( defined $step ) and ( $step eq 'START' )  ) {
    	$new_time = time ;
    	
    } ## END IF
    elsif ( ( defined $step ) and ( $step eq 'STOP' ) and ( defined $time ) ) {
    	$start_time = $$time ;
    	$stop_time = time ;
    	$new_time = ( $stop_time - $start_time ) ;
    	
    } ## END ELSIF
    else {
    	croak "Can't detect the step you are (start or stop time)\n" ;
    }
    
    return(\$new_time) ;
}
## END of SUB
     


1 ;


__END__

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc XXX.pm

=head1 Exports

=over 4

=item :ALL is ...

=back

=head1 AUTHOR

Franck Giacomoni E<lt>franck.giacomoni@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : xx / xx / 201x

version 2 : ??

=cut