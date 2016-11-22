package maths::combinatorics ;

use strict;
use warnings ;
use Exporter ;
use Carp ;
use Data::Dumper ;

## Specific Perl Modules (PFEM)
use maths::operations ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw( get_arrangements_without_repetition get_nb_arrangements_without_repetition);
our %EXPORT_TAGS = ( ALL => [qw( get_arrangements_without_repetition get_nb_arrangements_without_repetition)] );

=head1 NAME

My::combinatorics - An example module

=head1 SYNOPSIS

    use My::combinatorics;
    my $object = My::combinatorics->new();
    print $object->as_string;

=head1 DESCRIPTION

This module manage combinatorics algorithmes.

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



=head2 METHOD get_arrangements_without_repetition

	## Description : permet de générer la liste ordonnée de choix en tenant compte de leur ordre
	## Input : $nb_elts, $elts
	## Output : $arrangements
	## Usage : my ( $arrangements ) = arrangement( $nb_elts, $elts ) ;
	
=cut
## START of SUB
sub get_arrangements_without_repetition {
	## Retrieve Values
    my $self = shift ;
    my ( $nb_elts, $elts, $agregator ) = @_ ;
    
    my @arrangements = () ;
    
    for ( my $i = 0 ; $i <= ($nb_elts) ; $i++ ) {
		my $res = _get_inj( $i, $elts, $agregator ) ;
		@arrangements = ( @arrangements ,  @{$res} ) ;
	}
	
    return(\@arrangements) ;
}
## END of SUB

=head2 METHOD get_nb_arrangements_without_repetition

	## Description : permet de retourner le nbre d'arrangements sans repetition possible pour n elts
	## Input : $elts_nb
	## Output : $nb_arrangements
	## Usage : my ( $nb_arrangements ) = get_nb_arrangements_without_repetition( $elts_nb ) ;
	
=cut
## START of SUB
sub get_nb_arrangements_without_repetition {
	## Retrieve Values
    my $self = shift ;
    my ( $elts_nb ) = @_ ;
    my $nb_arrangements = 0 ;
    
    for ( my $i = 1 ; $i <= $elts_nb ; $i++ ) {
    	## calculs : nb = nb + n! / (n-i)!
    	my $ofactorial = maths::operations::new() ;
	    $nb_arrangements = $nb_arrangements + ($ofactorial->get_factorial($elts_nb)) / ($ofactorial->get_factorial($elts_nb - $i)) ;
	}
	    
    return($nb_arrangements) ;
}
## END of SUB


=head2 METHOD _get_inj

	## Description : private sub // permet de generer les injections pour un p et un ensemble donné
	## Initial script in Python by Zavonen : http://www.developpez.net/forums/anocode.php?id=acf816d6493339dad3973d71fa45ddd1
	## translate in perl by fgiacomoni
	## Input : $p, $ensemble
	## Output : $injonctionss
	## Usage : my ( $injonctions ) = _get_inj( $p, $Ensemble ) ;
	
=cut
## START of SUB
sub _get_inj {
	## Retrieve Values
    my ( $p, $ensemble, $agregator ) = @_ ;
    
	my @R = () ;
	
	if ($p == 1) {
		@R = () ;
		foreach (@{$ensemble}) { push(@R, $_) ; }
		return (\@R) ;
	}
	else {
		@R = () ;
		my $pos = 0 ;
		foreach my $x (@{$ensemble}) {
			my @tmp = @{$ensemble} ;
			splice(@tmp, $pos, 1) ; # supprime x
			my $PGI = &_get_inj($p-1, \@tmp, $agregator ) ;
			my @Cx = @{$PGI} ;
			my @tmp2 = () ;
			foreach my $a ( @Cx ) { push (@tmp2, $a.$agregator.$x) ; }
			@R = (@R, @tmp2) ;
			$pos++ ;		
		}
	}
	return (\@R) ;
}
## END of SUB


1 ;


__END__

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc combinatorics.pm

=head1 Exports

=over 4

=item :ALL is ...

=back

=head1 AUTHOR

Franck Giacomoni E<lt>franck.giacomoni@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : 30 / 04 / 2013

version 2 : ??

=cut