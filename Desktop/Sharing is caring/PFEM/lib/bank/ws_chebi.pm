package bank::ws_chebi ;

use strict;
use warnings ;
use Exporter ;
use Carp ;

use Data::Dumper ;

use LWP::Simple ; ## Lib de protocole HTTP de download
#use SOAP::Lite + trace => qw(all); ## SOAP for Kegg and Chebi web service version 0.67 :: trace with debug is for test
use SOAP::Lite ; ## SOAP for Kegg and Chebi web service version 0.67 :: trace is debug for test
import SOAP::Data qw(name);

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0" ;
our @ISA = qw(Exporter) ;
our @EXPORT = qw(start_chebi_ws get_ids_from_inchi get_ids_from_inchikey get_ids_from_name get_names_from_id get_inchi_from_id get_inchikey_from_id get_smiles_from_id get_mol_from_id);
our %EXPORT_TAGS = ( ALL => [qw( start_chebi_ws get_ids_from_inchi get_ids_from_inchikey get_ids_from_name get_names_from_id get_inchi_from_id get_inchikey_from_id get_smiles_from_id get_mol_from_id )] );

my %CHEBI_PARAM =(	'TOOL' => 'SOAP' ,
					'NAMESPACE' => 'http://www.ebi.ac.uk/webservices/chebi',
					'WSDL' => 'http://www.ebi.ac.uk/webservices/chebi/2.0/webservice?wsdl',
					'SERVICE' => 'http://www.ebi.ac.uk/ws/services/WSDbfetch?wsdl'
				) ;

=head1 NAME

bank::ws_chebi - A module to manage ChEBI ws.

=head1 SYNOPSIS

    use bank::ws_chebi ;
    my $object = bank::ws_chebi->new();
    print $object->as_string;

=head1 DESCRIPTION

This module managing ChEBI ws is based
on API description avalaible at : 
http://www.ebi.ac.uk/chebi/webServices.do

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

=head2 METHOD start_chebi_ws

	## Description : create a SOAP ChEBI connexion object
	## Input : N/A
	## Output : $osoap
	## Usage : my ( $osoap ) = start_chebi_ws() ;
	
=cut
## START of SUB
sub start_chebi_ws {
	## Retrieve Values
    my $self = shift ;
    
    my $osoap = undef ;
    $osoap = SOAP::Lite -> uri($CHEBI_PARAM{'NAMESPACE'}) -> proxy($CHEBI_PARAM{'WSDL'} ) ; # timeout => 6000
    
    return($osoap) ;
}
## END of SUB
     
=head2 METHOD get_ids_from_inchi

	## Description : get a list of ids from inchi structure by ChEBI soap method
	## Input : $osoap, $inchi
	## Output : $ids
	## Usage : my ( $ids ) = get_ids_from_inchi( $osoap, $inchi ) ;
	
=cut
## START of SUB
sub get_ids_from_inchi {
	## Retrieve Values
    my $self = shift ;
    my ( $osoap, $inchi ) = @_ ;
        
    my @ids = () ;
	
	# test : inchi = InChI=1S/C15H20O4/c1-10(7-13(17)18)5-6-15(19)11(2)8-12(16)9-14(15,3)4/h5-8,19H,9H2,1-4H3,(H,17,18)/b6-5+,10-7-/t15-/m1/s1
	
	# Setup method and parameters
	my $method = SOAP::Data->name('getLiteEntity')
	                         ->attr({xmlns => $CHEBI_PARAM{'NAMESPACE'}});
	                         
	my @params = ( SOAP::Data->name(search => $inchi),
	               SOAP::Data->name(searchCategory => 'INCHI/INCHI KEY'),
	               SOAP::Data->name(maximumResults => '200'),
	               SOAP::Data->name(stars => 'ALL'));

	# Call method
	my $som = $osoap->call($method => @params);

	## DETECTING A SOAP FAULT
	if ($som->fault) { carp $som->faultdetail ; }
	else { @ids = $som->valueof('//ListElement//chebiId'); }
    
    return(\@ids) ;
}
## END of SUB

=head2 METHOD get_ids_from_inchikey

	## Description : get a list of ids from inchi structure by ChEBI soap method
	## Input : $osoap, $inchikey
	## Output : $ids
	## Usage : my ( $ids ) = get_ids_from_inchikey( $osoap, $inchikey ) ;
	
=cut
## START of SUB
sub get_ids_from_inchikey {
	## Retrieve Values
    my $self = shift ;
    my ( $osoap, $inchikey ) = @_ ;
        
    my @ids = () ;
	
	# test : JLIDBLDQVAYHNE-QHFMCZIYSA-N
	
	# Setup method and parameters
	my $method = SOAP::Data->name('getLiteEntity')
	                         ->attr({xmlns => $CHEBI_PARAM{'NAMESPACE'}});
	                         
	my @params = ( SOAP::Data->name(search => $inchikey),
	               SOAP::Data->name(searchCategory => 'INCHI/INCHI KEY'),
	               SOAP::Data->name(maximumResults => '5'),
	               SOAP::Data->name(stars => 'ALL'));

	# Call method
	my $som = $osoap->call($method => @params);

	## DETECTING A SOAP FAULT
	if ($som->fault) { carp $som->faultdetail ; }
	else { @ids = $som->valueof('//ListElement//chebiId'); }
    
    return(\@ids) ;
}
## END of SUB

=head2 METHOD get_ids_from_name

	## Description : get a list of ids from name (common or synonyms) by ChEBI soap method
	## Input : $osoap, $name
	## Output : $ids
	## Usage : my ( $ids ) = get_ids_from_name( $osoap, $name ) ;
	
=cut
## START of SUB
sub get_ids_from_name {
	## Retrieve Values
    my $self = shift ;
    my ( $osoap, $name ) = @_ ;
    
    my @ids = () ;
    # test : Abscisic acid
	
	# Setup method and parameters
	my $method = SOAP::Data->name('getLiteEntity')
	                         ->attr({xmlns => $CHEBI_PARAM{'NAMESPACE'}});
	                         
	my @params = ( SOAP::Data->name(search => $name),
	               SOAP::Data->name(searchCategory => 'ALL NAMES'),
	               SOAP::Data->name(maximumResults => '200'),
	               SOAP::Data->name(stars => 'ALL'));

	# Call method
	my $som = $osoap->call( $method => @params );

	## DETECTING A SOAP FAULT
	if ($som->fault) { carp $som->faultdetail ; }
	else { @ids = $som->valueof('//ListElement//chebiId'); }
    
    return(\@ids) ;
}
## END of SUB

=head2 METHOD get_names_from_id

	## Description : get a list of names (common and synonyms) of a compound with the given chEBI ID
	## Input : $osoap, $id
	## Output : $names
	## Usage : my ( $names ) = get_names_from_id( $osoap, $id ) ;
	
=cut
## START of SUB
sub get_names_from_id {
	## Retrieve Values
    my $self = shift ;
    my ( $osoap, $id ) = @_ ;
    
    my @all_names = () ;
    # test : CHEBI:28937
    
    # Setup method and parameters
	my $method = SOAP::Data->name('getCompleteEntity')
	                         ->attr({xmlns => $CHEBI_PARAM{'NAMESPACE'}});

	my @params = ( SOAP::Data->name(chebiId => $id));
	# Call method
	my $som = $osoap->call( $method => @params );

	## DETECTING A SOAP FAULT
	if ($som->fault) { carp $som->faultdetail ; }
	else { 
		# get chebiAsciiName value
		my @ascii = $som->valueof('//chebiAsciiName'); 
		my @synonyms = $som->valueof('//Synonyms//data');
		my @iupac = $som->valueof('//IupacNames//data'); 
		
		@all_names = (@ascii, @synonyms, @iupac) ;
	}
    
    return(\@all_names) ;
}
## END of SUB

=head2 METHOD get_inchi_from_id

	## Description : get the inchi structure of a compound with the given chEBI ID
	## Input : $osoap, $id
	## Output : $inchi
	## Usage : my ( $inchi ) = get_inchi_from_id( $osoap, $id ) ;
	
=cut
## START of SUB
sub get_inchi_from_id {
	## Retrieve Values
    my $self = shift ;
    my ( $osoap, $id ) = @_ ;
    
    my $inchi = undef ;
    # test : CHEBI:28937
    
    # Setup method and parameters
	my $method = SOAP::Data->name('getCompleteEntity')
	                         ->attr({xmlns => $CHEBI_PARAM{'NAMESPACE'}});

	my @params = ( SOAP::Data->name(chebiId => $id));
	# Call method
	my $som = $osoap->call( $method => @params );

	## DETECTING A SOAP FAULT
	if ($som->fault) { carp $som->faultdetail ;  }
	else { $inchi = $som->valueof('//inchi'); }
    
    return(\$inchi) ;
}
## END of SUB

=head2 METHOD get_inchikey_from_id

	## Description : get the inchikey structure of a compound with the given chEBI ID
	## Input : $osoap, $id
	## Output : $inchikey
	## Usage : my ( $inchikey ) = get_inchikey_from_id( $osoap, $id ) ;
	
=cut
## START of SUB
sub get_inchikey_from_id {
	## Retrieve Values
    my $self = shift ;
    my ( $osoap, $id ) = @_ ;
    
    my $inchikey = undef ;
    # test : CHEBI:28937
    
    # Setup method and parameters
	my $method = SOAP::Data->name('getCompleteEntity')
	                         ->attr({xmlns => $CHEBI_PARAM{'NAMESPACE'}});

	my @params = ( SOAP::Data->name(chebiId => $id));
	# Call method
	my $som = $osoap->call( $method => @params );

	## DETECTING A SOAP FAULT
	if ($som->fault) { carp $som->faultdetail ;  }
	else { $inchikey = $som->valueof('//inchiKey'); }
    
    return(\$inchikey) ;
}
## END of SUB

=head2 METHOD get_smiles_from_id

	## Description : get the smiles structure of a compound with the given chEBI ID
	## Input : $osoap, $id
	## Output : $smiles
	## Usage : my ( $smiles ) = get_smiles_from_id( $osoap, $id ) ;
	
=cut
## START of SUB
sub get_smiles_from_id {
	## Retrieve Values
    my $self = shift ;
    my ( $osoap, $id ) = @_ ;
    
    my $smiles = undef ;
    # test : CHEBI:28937
    
    # Setup method and parameters
	my $method = SOAP::Data->name('getCompleteEntity')
	                         ->attr({xmlns => $CHEBI_PARAM{'NAMESPACE'}});

	my @params = ( SOAP::Data->name(chebiId => $id));
	# Call method
	my $som = $osoap->call( $method => @params );

	## DETECTING A SOAP FAULT
	if ($som->fault) { carp $som->faultdetail ;  }
	else { $smiles = $som->valueof('//smiles'); }
    
    return(\$smiles) ;
}
## END of SUB

=head2 METHOD get_mol_from_id

	## Description : get the 2d mol structure of a compound with the given chEBI ID
	## Input : $osoap, $id
	## Output : $mol
	## Usage : my ( $mol ) = get_mol_from_id( $osoap, $id ) ;
	
=cut
## START of SUB
sub get_mol_from_id {
	## Retrieve Values
    my $self = shift ;
    my ( $osoap, $id ) = @_ ;
    
    my $mol = undef ;
    # test : CHEBI:28937
    
    # Setup method and parameters
	my $method = SOAP::Data->name('getCompleteEntity')
	                         ->attr({xmlns => $CHEBI_PARAM{'NAMESPACE'}});

	my @params = ( SOAP::Data->name(chebiId => $id));
	# Call method
	my $som = $osoap->call( $method => @params );

	## DETECTING A SOAP FAULT
	if ($som->fault) { carp $som->faultdetail ;  }
	else {
		if ( ( $som->valueof('//ChemicalStructures//type') ne 'mol' ) 
			and ( $som->valueof('//ChemicalStructures//dimension') ne '2D' ) ) {
				carp "The available chemical structure for cpd $id is not a mol 2D format\n" ; 
		}
		else {
			$mol = $som->valueof('//ChemicalStructures//structure'); 
		}
	}
    return(\$mol) ;
}
## END of SUB


1 ;


__END__

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc bank::ws_chebi.pm

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