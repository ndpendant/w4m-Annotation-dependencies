package chem::obabel ;

use strict;
use warnings ;
use Exporter ;
use Carp ;

use Data::Dumper ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw( compare_smiles );
our %EXPORT_TAGS = ( ALL => [qw( compare_smiles )] );

=head1 NAME

chem::obabel - A module to interaction with openbabel tool

=head1 SYNOPSIS

    use chem::obabel ;
    my $object = chem::obabel->new();
    print $object->as_string;

=head1 DESCRIPTION

This module is a frame of openbabel exe program

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

=head2 METHOD obabel_exists

	## Description : check if obabel exists in your environment
	## Input : N/A
	## Output : $state
	## Usage : my ( $state ) = obabel_exists() ;
	
=cut
## START of SUB
sub _obabel_exists {
	## Retrieve Values
    
    my $state = undef ;
    my $handler = undef ;
    $handler = `obabel -V` ;
    
    if ( $handler =~/Open Babel\s+([0-9\.]+)\s+\-\-\s+([A-Za-z0-9\s]+)\s+\-\-\s+(.*)/) {  	$state = 1 ;    }
    else { 	croak "OBabel is not in your PATH or ENVT.\n It return $handler\n" ; }
    
    return($state) ;
}
## END of SUB

=head2 METHOD compare_smiles

	## Description : compare a ref smiles against a record smiles using the tanimoto similarity coeficien
	## Input : $ref_smiles, $rec_smiles, $threshold
	## Output : $state : (PARTIAL or EXACT) matche
	## Usage : my ( var2 ) = compare_smiles( $ref_smiles, $rec_smiles, $threshold ) ;
	
=cut
## START of SUB
sub compare_smiles {
	## Retrieve Values
    my $self = shift ;
    my ( $ref_smiles, $rec_smiles, $threshold ) = @_ ;
    
    _obabel_exists ;
    
    my $state = undef ;
    
    ## test of values
    # ref = C\C(\C=C\[C@@]1(O)C(C)=CC(=O)CC1(C)C)=C\C(O)=O
    # rec = CC1=CC(=O)CC(C1(C=CC(=CC(=O)O)C)O)(C)C (Tanimoto = 1)
    # rec = CC1=CC(=O)CC(C1(C=CC(=CC(=O)O)C)O)(C)C(F)(F)F (Tanimoto = 0.849315)
    # rec = C1=CC=C2C(=C1)C(=CN2)CC(C(=O)O)N (Tanimoto from first mol = 0.121951)
    
    if ( ( defined $ref_smiles ) and ( defined $rec_smiles )  ) {
    	## obabel exe
    	my $res =`obabel -:$ref_smiles -:$rec_smiles -ofpt 2>&1` ;
		if ($res =~/>\s+Tanimoto\s+from\s+first\s+mol\s+=\s+([0-9\.]+)/) {
			## threshold testing
			if ($1 >=  $threshold) {
				$state = 'EXACT' ;
			}
			else {
				$state = 'PARTIAL' ;
			}
		}
    } ## END IF
    else {
    	croak "No comparison possible with a ref and a record\n" ;
    }
    return(\$state) ;
}
## END of SUB


1 ;


__END__

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc chem::obabel.pm

=head1 Exports

=over 4

=item :ALL is ...

=back

=head1 AUTHOR

Franck Giacomoni E<lt>franck.giacomoni@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : 29 / 07 / 2013

version 2 : ??

=cut