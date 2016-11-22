package chem::features ;

#use strict;
use warnings ;
use Exporter ;
use Carp ;
use Data::Dumper ;

## dedicated lib
use Chemistry::File::Formula ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0" ;
our @ISA = qw(Exporter) ;
our @EXPORT = qw( getMass getAtoms mass_transaction formula_transaction ) ;
our %EXPORT_TAGS = ( ALL => [qw( getMass getAtoms mass_transaction formula_transaction )] ) ;

=head1 NAME

chem::feature - A module for get chem feature of a mol file

=head1 SYNOPSIS

    use chem::feature ;
    my $object = feature->new() ;

=head1 DESCRIPTION

This module get chemical features (mass, formula...) of a mol file.

=head1 METHODS

Methods are :

=head2 METHOD new

	## Description : new
	## Input : $self
	## Ouput : bless $self ;
	## Usage : new() ;

=cut
## START of SUB
sub new {
    ## Variables
    my $self={};
    bless($self) ;
    return $self ;
}
### END of SUB

=head2 METHOD getMass

	## Description : permet de generer la masse monoisotopique d'un mol file
	## Input : $file
	## Output : $mass
	## Usage : my ( $mass ) = getMass( $file ) ;
	
=cut
## START of SUB
sub getMass {
	## Retrieve Values
    my $self = shift ;
    my ( $Exe, $file ) = @_ ;
    my $mass = -1 ;
    
    ## TODO... extraire le path de l'exe : le mettre en envt
    my $status = `$Exe mass -s false $file 2>&1`;
	#  	-s, --single  [true|false] in case of multi-fragment molecules: 
	#	takes largest fragment if true, takes whole molecule if false (default: false)
	# it possible use "cxcalc iformula" to include isotope
	
	# if command was well executed output looks like this
	#	id      mass
	#	1       154.2493
	
	if ( substr( $status, 0, 2 ) eq 'id' ) {
		my @Result = split('\t', $status) ;
		$mass = $Result[2] ;
		chomp $mass ;
	}
	else { 	$mass = -2 ; }
    
    
    return( $mass ) ;
}
## END of SUB

=head2 METHOD getAtoms

	## Description : permet de generer la formule elemantaire d'un mol file
	## Input : $file
	## Output : $formula
	## Usage : my ( $mass ) = getAtoms( $file ) ;
	
=cut
## START of SUB
sub getAtoms {
	## Retrieve Values
    my $self = shift ;
    my ( $Exe, $file ) = @_ ;
    my $formula = undef ;
    
    ## TODO... extraire le path de l'exe : le mettre en envt
    my $status = `$Exe formula -s false $file 2>&1`;
	#  	-s, --single  [true|false] in case of multi-fragment molecules: 
	#	takes largest fragment if true, takes whole molecule if false (default: false)
	# it possible use "cxcalc iformula" to include isotope
	
	# if command was well executed output looks like this
	#	id      Formula
	#	1       C19H28O3
	
	if ( substr( $status, 0, 2 ) eq 'id' ) {
		my @Result = split('\t', $status) ;
		$formula = $Result[2] ;
		chomp $formula ;
	}
	else { 	$formula = undef ; }
    
    
    return( $formula ) ;
}
## END of SUB


=head2 METHOD mass_transaction

	## Description : permet de +/- mass sur une masse référence
	## Input : $refmass, $mass_to_add, $type [add|del]
	## Output : $new_mass
	## Usage : my ( $new_mass ) = mass_transaction( $refmass, $mass_to_add ) ;
	
=cut
## START of SUB
sub mass_transaction {
	## Retrieve Values
    my $self = shift ;
    my ( $refmass, $mass_to_add, $type ) = @_ ;
    my $new_mass = undef ;
    
    if ( (defined $refmass) and (defined $mass_to_add) ) {
    	
    	## Nbre de chiffre apres la virgule de la ref :
    	my ( $decimal, $nb, $round_mass ) = ( 0, 0 , 0 ) ;
    	if ( $refmass =~ /(\d+).(\d+)/ ) { 	$decimal = $2 ;   }
    	else { 					    		$decimal = 00 ; } ## par defaut si le nombre est un entier
    	
    	$nb = length ( $decimal ) ;
    	
    	## Arrondi :
    	if (defined $nb) { 	$round_mass = sprintf("%.".$nb."f", $mass_to_add) ; }
    	
    	## Add mass to ref mass
    	if ( ( defined $type ) and ( $type eq 'add' ) ) {
    		$new_mass = $refmass + $round_mass ;
    	}
    	## del mass to ref mass
    	elsif ( ( defined $type ) and ( $type eq 'del' ) ) {
    		$new_mass = $refmass - $round_mass ;
    	}
    	else { 	croak "cant' work with undef type of transaction in mass_transaction module\n" ; } 
    }
    else {
    	croak "Can't work with undef value in mass_transaction module\n" ;
    }
    
    
    return($new_mass) ;
}
## END of SUB

=head2 METHOD formula_transaction

	## Description : permet de +/- atomes sur une formule de reference en utilisant le package perlmol !
	## Input : $ref_formula, $atoms_to_add, $type [add|del]
	## Output : $new_formula
	## Usage : my ( $new_formula ) = formula_transaction( $ref_formula, $atoms_to_add ) ;
	
=cut
## START of SUB
sub formula_transaction {
	## Retrieve Values
    my $self = shift ;
    my ( $ref_formula, $atoms_to_add, $type ) = @_ ;
    my $new_formula = undef ;
    
    my %formula = Chemistry::File::Formula->parse_formula("$ref_formula");
    my %atoms = Chemistry::File::Formula->parse_formula("$atoms_to_add");
    
    ## pour chaque atom a ajouter/deleter
    foreach my $elt ( keys %atoms ) {
    	## verifie que la formule du composé ref en contient
    	if ( ( defined $formula{$elt} ) and ( $formula{$elt} > 0 ) ) {
    		## add atom to formula
    		if ( (defined $type) and ( $type eq 'add') ) {
    			my $new_value = $formula{$elt} + $atoms{$elt} ;
    			$formula{$elt} = $new_value ;
    		}
    		## del atom to formula only in one side
    		elsif ( (defined $type) and ( $type eq 'del') ) {
    			if ( $formula{$elt} > $atoms{$elt} ) { my $new_value = $formula{$elt} - $atoms{$elt} ; $formula{$elt} = $new_value ; }
    			else { croak "The atom number to delete is > than the atom number of the molecule\n" ; }
    		}
    		else { 	croak "cant' work with undef type of transaction in formula_transaction module\n" ; }    		
    	}
    	## si le du composé ref n'en contient pas : on le rajoute !
    	else { 	$formula{$elt} = $atoms{$elt} ;  	}
    }
    
    ## create a fake but usefull formula !
    $mol = Chemistry::Mol->new(id => 'm123', name => 'my mol') ;
	foreach my $atom (keys %formula) {
		for ( my $i = 0 ; $i < $formula{$atom} ; $i++ ) {    my $c = $mol->new_atom(symbol => "$atom");  }
	}
	my $formula = $mol->print( format => 'formula'  ) ;
    
    return($formula) ;
}
## END of SUB


1 ;


__END__

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc conf.pm


=head1 Exports

=over 4

=item :ALL is getMass getAtoms mass_transaction formula_transaction

=back

=head1 AUTHOR

Franck Giacomoni E<lt>franck.giacomoni@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : 10 / 02 / 2013

version 2 : ??

=cut