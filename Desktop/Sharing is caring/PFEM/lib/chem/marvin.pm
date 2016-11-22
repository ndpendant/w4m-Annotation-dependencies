package chem::marvin ;

use strict ;
use warnings ;
use Exporter ;
use Carp ;

use Data::Dumper ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS) ;

our $VERSION = "1.0" ;
our @ISA = qw(Exporter) ;
our @EXPORT = qw( new xx) ;
our %EXPORT_TAGS = ( ALL => [qw( new xx)] ) ;

=head1 NAME

chem::marvin - A module to manage marvin suite in a perl context

=head1 SYNOPSIS

    use chem::marvin ;
    my $object = chem::marvin->new();
    print $object->as_string;

=head1 DESCRIPTION

This module does encapsulate all marvin bean pluggins

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


=head2 METHOD get_average_mw

	## Description : permet de generer in silico average mw via suite chemaxon marvin bean
	## Input : $mol
	## Output : $average_mw
	## Usage : my ( $average_mw ) = get_average_mw( $mol ) ;
	
=cut
## START of SUB
sub get_average_mw {
	## Retrieve Values
    my $self = shift ;
    my ( $mol ) = @_ ;
    
    my $average_mw = undef ;
    
    if ( $mol ) {
    	
		$average_mw = `cxcalc mass --precision 7 $mol 2>&1`;
#		Calculator plugin: mass. Molecule mass calculation.
#		Usage:
#		 cxcalc [general options] [input files/strings] mass
#		[mass options] [input files/strings]
#		
#		mass options:
#		 -h, --help       this help message
#		 -p, --precision  <floating point precision as number of fractional digits: 0-8 or inf> (default: precision of the least precise atomic mass)
#		 -s, --single     [true|false] in case of multi-fragment molecules: takes largest fragment if true, takes whole molecule if false (default: false)
#		
#		Multiple values for the same parameter should be quoted and separated by commas without space (e.g.: -t "v1,v2,v3" where v1, v2, v3 are the specified values of parameter t).
#		
#		Output :
#		id	Mass
#		1	422.3396000

		$average_mw = _check_get_object_status($average_mw);
		
		if ( $average_mw ne 'NA' ) {
			if ( $average_mw =~/id\s+Mass\n(.*)/ ) {
				my @lines = () ;
				@lines = split (/\n/, $average_mw ) ;
				if ( scalar @lines > 0 ) {
					foreach my $line ( @lines ) {
						if ($line =~ /(\d+)\s+(.*)/ ) {
							$average_mw = $2 ; 
						}
					}
				}
			}
		}
	}
	else {
		croak "No Mol file for average_mass processing\n" ;
	}
    
    return($average_mw) ;
}
## END of SUB

=head2 METHOD get_monoisotopic_mw

	## Description : permet de generer in silico monoisotopic mw via suite chemaxon marvin bean
	## Input : $mol
	## Output : $monoisotopic_mw
	## Usage : my ( $monoisotopic_mw ) = get_monoisotopic_mw( $mol ) ;
	
=cut
## START of SUB
sub get_monoisotopic_mw {
	## Retrieve Values
    my $self = shift ;
    my ( $mol ) = @_ ;
    
    my $monoisotopic_mw = undef ;
    
    if ( $mol ) {
    	
		$monoisotopic_mw = `cxcalc exactMass --precision 7 $mol 2>&1`;
#		print $monoisotopic_mw."\n" ;
#		Calculator plugin: exactmass. Exact molecule mass calculation based on the most frequent natural isotopes of the elements.
#		Usage:
#		  cxcalc [general options] [input files/strings] exactmass
#		[exactmass options] [input files/strings]
#		
#		exactmass options:
#		  -h, --help       this help message
#		  -p, --precision  <floating point precision as number of fractional digits: 0-8 or inf> (default: precision of the least precise atomic mass)
#		  -s, --single     [true|false] in case of multi-fragment molecules:  takes largest fragment if true, takes whole molecule if false (default: false)
#		
#		Multiple values for the same parameter should be quoted and separated by commas without space (e.g.: -t "v1,v2,v3" where v1, v2, v3 are the specified values of parameter t).
#		
#		Output :
#		id	Exact mass
#		1	422.0849114

		$monoisotopic_mw = _check_get_object_status($monoisotopic_mw);
		
		if ( $monoisotopic_mw ne 'NA' ) {
			if ( $monoisotopic_mw =~/id\s+Exact mass\n(.*)/ ) {  
				my @lines = () ;
				@lines = split (/\n/, $monoisotopic_mw ) ;
				if ( scalar @lines > 0 ) {
					foreach my $line ( @lines ) {
						if ($line =~ /(\d+)\s+(.*)/ ) {
							$monoisotopic_mw = $2 ; 
						}
					}
				}
			}
		}
	}
	else {
		croak "No Mol file for exact_mass processing\n" ;
	}
    
    return($monoisotopic_mw) ;
}
## END of SUB

=head2 METHOD get_iupac_name

	## Description : permet de generer in silico iupac name via suite chemaxon marvin bean 
	## Input : $mol
	## Output : $iupac_name
	## Usage : my ( $iupac_name ) = get_iupac_name( $mol ) ;
	
=cut
## START of SUB
sub get_iupac_name {
	## Retrieve Values
    my $self = shift ;
    my ( $mol ) = @_ ;
    
    my $iupac_name = undef ;
    
    if ( $mol ) {
    	$iupac_name = `molconvert name $mol 2>&1` ;
    	$iupac_name =~ s/\n// ;
    	$iupac_name = _check_get_object_status($iupac_name) ;
    }
	else {
		croak "No Mol file for iupac_name processing\n" ;
	}
	
    return($iupac_name) ;
}
## END of SUB

=head2 METHOD get_elemental_formula

	## Description : permet de generer in silico elemental formula via suite chemaxon marvin bean 
	## Input : $mol
	## Output : $elemental_formula
	## Usage : my ( $elemental_formula ) = get_elemental_formula( $mol ) ;
	
=cut
## START of SUB
sub get_elemental_formula {
	## Retrieve Values
    my $self = shift ;
    my ( $mol ) = @_ ;
    
    my $elemental_formula = undef ;
    
    if ( $mol ) {
    	$elemental_formula = `cxcalc formula -s false $mol 2>&1`;
    	#		Calculator plugin: formula. Molecular formula calculation.
#		Usage:
#		  cxcalc [general options] [input files/strings] formula
#		[formula options] [input files/strings]
#		
#		formula options:
#		  -h, --help    this help message
#		  -s, --single  [true|false] in case of multi-fragment molecules: takes largest fragment if true,  takes whole molecule if false (default: false)
#		
#		Output :
#		id	Formula
#		1	C19H18O11

    	$elemental_formula = _check_get_object_status($elemental_formula);
    	
    	if ( $elemental_formula ne 'NA' ) {
			if ( $elemental_formula =~/id\s+Formula\n(.*)/ ) {  
				my @lines = () ;
				@lines = split (/\n/, $elemental_formula ) ;
				if ( scalar @lines > 0 ) {
					foreach my $line ( @lines ) {
						if ($line =~ /(\d+)\s+(.*)/ ) {
							$elemental_formula = $2 ; 
						}
					}
				}
			}
		}
    }
	else {
		croak "No Mol file for elemental_formula processing\n" ;
	}
	
    return($elemental_formula) ;
}
## END of SUB

=head2 METHOD get_inchi_identifier

	## Description : permet de generer in silico inchi_identifier via suite chemaxon marvin bean 
	## Input : $mol
	## Output : $inchi_identifier
	## Usage : my ( $inchi_identifier ) = get_inchi_identifier( $mol ) ;
	
=cut
## START of SUB
sub get_inchi_identifier {
	## Retrieve Values
    my $self = shift ;
    my ( $mol ) = @_ ;
    
    my $inchi_identifier = undef ;
    
    if ( $mol ) {
    	$inchi_identifier = `molconvert inchi $mol 2>&1`;
    	
#		Output :
#		InChI=1S/C19H18O11/c20-4-11-15(25)17(27)18(28)19(30-11)12-8(23)3-10-13(16(12)26)14(24)5-1-6(21)7(22)2-9(5)29-10/h1-3,11,15,17-23,25-28H,4H2/t11-,15-,17+,18-,19+/m1/s1
#		AuxInfo=1/0/N:8,7,13,29,9,19,17,23,10,12,6,25,11,14,5,21,4,3,2,30,20,18,24,15,28,22,26,27,16,1/it:im/rA:31OC.oC.oC.eC.oC.oCCCCCCCCOOCOCOCOCOCOOOCOH/rB:s1;s2;s3;s4;s1s5
		
		$inchi_identifier = _check_get_object_status($inchi_identifier);
		if ( $inchi_identifier ne 'NA' ) {
			if ( $inchi_identifier =~/InChI=(.*)\nAuxInfo=/ ) {  $inchi_identifier = 'InChI='.$1 ; }
		}
    }
    else {
		croak "No Mol file for elemental_formula processing\n" ;
	}

    return($inchi_identifier) ;
}
## END of SUB

=head2 METHOD get_inchi_key

	## Description : permet de generer in silico inchi key via suite chemaxon marvin bean 
	## Input : $mol
	## Output : $inchi_key
	## Usage : my ( $inchi_key ) = get_inchi_key( $mol ) ;
	
=cut
## START of SUB
sub get_inchi_key {
	## Retrieve Values
    my $self = shift ;
    my ( $mol ) = @_ ;
    
    my $inchi_key = undef ;
    
    if ( $mol ) {
    	$inchi_key = `molconvert inchikey $mol 2>&1`;
    	
#		Output :
#		InChIKey=AEDDIBAIWPIIBD-ZJKJAXBQSA-N
		
		$inchi_key = _check_get_object_status($inchi_key);
		if ( $inchi_key ne 'NA' ) {
			if ( $inchi_key =~/InChIKey=(.*)/ ) {  $inchi_key = $1 ; }
		}
    }
    else {
		croak "No Mol file for elemental_formula processing\n" ;
	}

    return($inchi_key) ;
}
## END of SUB

=head2 METHOD get_canonical_smiles

	## Description : permet de generer in silico canonical_smiles via suite chemaxon marvin bean 
	## Input : $mol
	## Output : $canonical_smiles
	## Usage : my ( canonical_smiles ) = get_canonical_smiles( $mol ) ;
	
=cut
## START of SUB
sub get_canonical_smiles {
	## Retrieve Values
    my $self = shift ;
    my ( $mol ) = @_ ;
    
    my $canonical_smiles = undef ;
    
    if ( $mol ) {
    	$canonical_smiles = `molconvert smiles $mol 2>&1`;
#		Output :
#		[H][C@]1(O[C@H](CO)[C@@H](O)[C@H](O)[C@H]1O)C1=C(O)C2=C(OC3=C(C=C(O)C(O)=C3)C2=O)C=C1
		
		$canonical_smiles = _check_get_object_status($canonical_smiles);
		if ( $canonical_smiles ne 'NA' ) {
			chomp $canonical_smiles ;
		}

    }
    else {
		croak "No Mol file for canonical_smiles processing\n" ;
	}

    return($canonical_smiles) ;
}
## END of SUB

=head2 METHOD get_cas_number

	## Description : permet de generer in silico CAS Number via le WS CACTUS interrogeable par la suite chemaxon marvin bean à partir du smiles (version 6.0 de molconverter)
	## Input : $mol
	## Output : $cas_number
	## Usage : my ( $cas_number ) = get_cas_number( $mol ) ;
	
=cut
## START of SUB
sub get_cas_number {
	## Retrieve Values
    my $self = shift ;
    my ( $mol ) = @_ ;
    
    my $cas_number = undef ;
    my $canonical_smiles = undef ;
    
    if ( $mol ) {
		$canonical_smiles = `molconvert smiles $mol 2>&1`;
#		Output :
#		[H][C@]1(O[C@H](CO)[C@@H](O)[C@H](O)[C@H]1O)C1=C(O)C2=C(OC3=C(C=C(O)C(O)=C3)C2=O)C=C1
		
		$canonical_smiles = _check_get_object_status($canonical_smiles);
		if ( $canonical_smiles ne 'NA' ) {
			chomp $canonical_smiles ;
			
			$cas_number = `molconvert name:cas# -s "$canonical_smiles" 2>&1`;
			$cas_number = _check_get_object_status($cas_number);
			if ( $cas_number ne 'NA' ) {
				chomp $cas_number ;
			}
		}
    }
    else {
		croak "No Mol file for the cas_number processing\n" ;
	}

    return($cas_number) ;
}
## END of SUB

=head2 METHOD get_pka

	## Description : permet de generer in silico pka via suite chemaxon marvin bean 
	## Input : $mol
	## Output : $pka
	## Usage : my ( $pka ) = get_pka( $mol ) ;
	
=cut
## START of SUB
sub get_pka {
	## Retrieve Values
    my $self = shift ;
    my ( $mol ) = @_ ;
    
    my $pka = undef ;
    my ( $apka, $bpka ) = ( 0, 0 ) ;
    
	$pka = `cxcalc pka -i -15 -x 25 -a 1 -b 1 -d small $mol 2>&1`;
 	
#		Calculator plugin: pka. pKa calculation.
#		Usage:
#		  cxcalc [general options] [input files/strings] pka
#		[pka options] [input files/strings]
#		
#		pka options:
#		  -h, --help                     this help message
#		  -p, --precision                <floating point precision as number of  fractional digits: 0-8 or inf> (default: 2)
#		  -t, --type                     [pKa|acidic|basic] (default: pKa)
#		  -m, --mode                     [macro|micro] (default: macro)
#		  -P, --prefix                   [static|dynamic] (default: static)
#		  -d, --model                    [small|large] calculation model small: optimized for at most 8 ionizable atoms //  large: optimized for a large number of ionizable atoms (default: small)
#		  -i, --min                      <min basic pKa> (default: -10)
#		  -x, --max                      <max acidic pKa> (default: 20)
#		  -T, --temperature              <temperature in Kelvin> (default: 298 K)
#		  -a, --na                       <number of acidic pKa values displayed>  (default: 2)
#		  -b, --nb                       <number of basic pKa values displayed>   (default: 2)
#		      --considertautomerization  [true|false] consider tautomerization    (default: false)
#		  -L, --correctionlibrary        <correction library ID>
#		
#		Example:
#		  cxcalc pka -i -15 -x 25 -a 3 -b 3 -d large test.mol
#		
#		Ouput : if command was well executed output looks like this
#		id		apKa1	apKa2	bpKa1	bpKa2	atoms
#		1		13,86	15,38	-2,21	-3,07	20,19,1,19
		
		if ( $pka ne 'NA' ) {
			if ( $pka =~/id\s+apKa1\s+bpKa1\s+atoms\n(.*)/ ) {
				my @lines = () ;
				@lines = split (/\n/, $pka ) ;
				if ( scalar @lines > 0 ) {
					foreach my $line ( @lines ) {
						if ($line =~ /(\d+)\s+(.*)\s+(.*)\s+(.*)/ ) {
							( $apka, $bpka ) = ( $2, $3 ) ;
						}
					}
				}
			}
		}
    
    
    return($apka, $bpka) ;
}
## END of SUB

## Private Fonction : permet de gérer les exceptions de la suite marvin bean
## Input : $status
## Ouput : $clean_status
sub _check_get_object_status {
    ## Retrieve Values
    my ( $status ) = @_;
    
    if ( $status ) {
		# Mol file was not found
		if ( $status =~ /.* not found/) 
			{ $status = 'NA' ; }
		# An error occured
		elsif ( $status =~ /.* error: (.*)/) 
			{ $status = 'NA' ; }
		# abnormal termination
		elsif ( $? != 0 ) 
			{ $status = 'NA' ; }
		# Mol file was not found
		elsif ($status =~ /.*FileNotFoundException.*/ )
			{ $status = 'NA' ; }
		# An error occured
		elsif ($status =~ /.*MolFormatException.*/ ) 
			{ $status = 'NA' ; }
	}
	elsif (not $status) {
		$status = 'NA' ;
	}
    
    return($status) ;
}
### END of SUB


1 ;


__END__

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc chem::marvin.pm

=head1 Exports

=over 4

=item :ALL is ...

=back

=head1 AUTHOR

Franck Giacomoni E<lt>franck.giacomoni@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : 12 / 06 / 2013

version 2 : ??

=cut