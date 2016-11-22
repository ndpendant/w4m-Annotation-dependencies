package bank::ws_pubchem ;

use strict;
use warnings ;
use Exporter ;
use Carp ;

use Data::Dumper ;
use LWP::Simple ;
use JSON ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS) ;

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw( get_ids_from_smiles get_ids_from_common_name get_names_from_cid get_isomeric_smiles_from_cid get_canonical_smiles_from_cid get_inchi_from_cid);
our %EXPORT_TAGS = ( ALL => [qw( get_ids_from_smiles get_ids_from_common_name get_names_from_cid get_isomeric_smiles_from_cid get_canonical_smiles_from_cid get_inchi_from_cid )] );

=head1 NAME

bank::ws_pubchem - A module to manage pubchem ws.

=head1 SYNOPSIS

    use bank::ws_pubchem ;
    my $object = bank::ws_pubchem->new();
    print $object->as_string;

=head1 DESCRIPTION

This module managing pubchem ws is based
on API description avalaible at : 
http://pubchem.ncbi.nlm.nih.gov/pug_rest/PUG_REST.html

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

=head2 METHOD get_ids_from_smiles

	## Description : get a list of IDs from a "smiles" structure
	## Input : $smiles, $output_format
	## Output : $output
	## Usage : my ( $output ) = get_ids_from_smiles( $smiles, $output_format ) ;
	
=cut
## START of SUB
sub get_ids_from_smiles {
	## Retrieve Values
    my $self = shift ;
    my ( $smiles, $output_format ) = @_ ;
    
    my $output = undef ;
    
    if ( ( defined $smiles ) and ( defined $output_format )  ) {
    	## build url
    	my $url = 'http://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/smiles/'.$smiles.'/cids/'.$output_format ;
    	$output = get("$url") or carp "Couldn't get ids with this smiles $smiles !" ;
    	
    } ## END IF
    else {
    	croak "Missing argvt (smiles or format) for get_ids_from_smiles method\n" ;
    }
	## output can be manage by the read_ids_from_json method !
    return($output) ;
}
## END of SUB

=head2 METHOD get_ids_from_common_name

	## Description : get a list of IDs from a "common name" compound
	## Input : $common_name, $output_format
	## Output : $output
	## Usage : my ( $output ) = get_ids_from_common_name( $common_name, $output_format ) ;
	
=cut
## START of SUB
sub get_ids_from_common_name {
	## Retrieve Values
    my $self = shift ;
    my ( $common_name, $output_format ) = @_ ;
    
    my $output = undef ;
    
    if ( ( defined $common_name ) and ( defined $output_format )  ) {
    	## build url
    	my $url = 'http://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/'.$common_name.'/cids/'.$output_format ;
    	$output = get("$url") or carp "Couldn't get ids with this common name $common_name !" ;
    	
    } ## END IF
    else {
    	croak "Missing argvt (name or format) for get_ids_from_common_name method\n" ;
    }
    ## output can be manage by the read_ids_from_json method !
    return($output) ;
}
## END of SUB

=head2 METHOD get_names_from_cid

	## Description : get compound names of a compound from a given cid
	## Input : $id, $output_format
	## Output : $output
	## Usage : my ( $output ) = get_names_from_cid( $id, output_format ) ;
	
=cut
## START of SUB
sub get_names_from_cid {
	## Retrieve Values
    my $self = shift ;
    my ( $id, $output_format ) = @_ ;
    
    my $output = undef ;
    
    if ( ( defined $id ) and ( defined $output_format )  ) {
    	## build url
    	my $url = 'http://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/'.$id.'/synonyms/'.$output_format ;
    	$output = get("$url") or carp "Couldn't get names with this cid $id!" ;
    	
    } ## END IF
    else {
    	croak "Missing argvt (name or format) for get_names_from_cid method\n" ;
    }
    ## output can be manage by the read_names_from_json method !
    return($output) ;
}
## END of SUB

=head2 METHOD get_isomeric_smiles_from_cid

	## Description : get the isomeric smiles structure from a given cid
	## Input : $cid, $output_format
	## Output : $output
	## Usage : my ( $output ) = get_isomeric_smiles_from_cid( $cid, $output_format ) ;
	
=cut
## START of SUB
sub get_isomeric_smiles_from_cid {
	## Retrieve Values
    my $self = shift ;
    my ( $cid, $output_format ) = @_ ;
    
    my $output = undef ;
    
    if ( ( defined $cid ) and ( defined $output_format )  ) {
    	## build url
    	my $url = 'http://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/'.$cid.'/property/IsomericSMILES/'.$output_format ;
    	$output = get("$url") or carp "Couldn't get isomeric smiles with this cid $cid!" ;
    	
    } ## END IF
    else {
    	croak "Missing argvt (cid or format) for get_isomeric_smiles_from_cid method\n" ;
    }
	## output can be manage by read_isomeric_smiles_from_json method !
    return($output) ;
}
## END of SUB

=head2 METHOD get_canonical_smiles_from_cid

	## Description : get the canonical_smiles structure from a given cid
	## Input : $cid, $output_format
	## Output : $output
	## Usage : my ( $output ) = get_canonical_smiles_from_cid( $cid, $output_format ) ;
	
=cut
## START of SUB
sub get_canonical_smiles_from_cid {
	## Retrieve Values
    my $self = shift ;
    my ( $cid, $output_format ) = @_ ;
    
    my $output = undef ;
    
    if ( ( defined $cid ) and ( defined $output_format )  ) {
    	## build url
    	my $url = 'http://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/'.$cid.'/property/CanonicalSMILES/'.$output_format ;
    	$output = get("$url") or carp "Couldn't get canonical smiles with this cid $cid!" ;
    	
    } ## END IF
    else {
    	croak "Missing argvt (cid or format) for get_canonical_smiles_from_cid method\n" ;
    }
	## output can be manage by read_canonical_smiles_from_json method !
    
    return($output) ;
}
## END of SUB

=head2 METHOD get_inchi_from_cid

	## Description : get the inchi structure from a given cid
	## Input : $cid, $output_format
	## Output : $output
	## Usage : my ( $output ) = get_inchi_from_cid( $cid, $output_format ) ;
	
=cut
## START of SUB
sub get_inchi_from_cid {
	## Retrieve Values
    my $self = shift ;
    my ( $cid, $output_format ) = @_ ;
    
    my $output = undef ;
    
    if ( ( defined $cid ) and ( defined $output_format )  ) {
    	## build url
    	my $url = 'http://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/'.$cid.'/property/InChI/'.$output_format ;
    	$output = get("$url") or carp "Couldn't get InChI with this cid $cid!" ;
    	
    } ## END IF
    else {
    	croak "Missing argvt (cid or format) for get_inchi_from_cid method\n" ;
    }
	## output can be manage by read_inchi_from_json method !
    return($output) ;
}
## END of SUB

=head2 METHOD get_inchikey_from_cid

	## Description : get the inchikey structure from a given cid
	## Input : $cid, $output_format
	## Output : $output
	## Usage : my ( $output ) = get_inchikey_from_cid( $cid, $output_format ) ;
	
=cut
## START of SUB
sub get_inchikey_from_cid {
	## Retrieve Values
    my $self = shift ;
    my ( $cid, $output_format ) = @_ ;
    
    my $output = undef ;
    
    if ( ( defined $cid ) and ( defined $output_format )  ) {
    	## build url
    	my $url = 'http://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/'.$cid.'/property/InChIKey/'.$output_format ;
    	$output = get("$url") or carp "Couldn't get inchikey with this cid $cid!" ;
    	
    } ## END IF
    else {
    	croak "Missing argvt (cid or format) for get_inchi_from_cid method\n" ;
    }
	## output can be manage by read_inchikey_from_json method !
    return($output) ;
}
## END of SUB


## -----------------------  decode and read json output ------------------- ## 

=head2 METHOD read_inchi_from_json

	## Description : read any list of inchi in a json format_from a _unik_id
	## Input : $json_text
	## Output : $inchi
	## Usage : my ( $inchi ) = read_inchi_from_json( $json_text ) ;
	
=cut
## START of SUB
sub read_inchi_from_json {
	## Retrieve Values
    my $self = shift ;
    my ( $json_text ) = @_ ;
    
    my $inchi = undef ;
    my $temp_scalar = undef ;
    
    if ( defined $json_text ) {
    	$temp_scalar = decode_json $json_text ;
    	if ( defined $temp_scalar ) {
	    	if ( exists $temp_scalar->{'PropertyTable'}{'Properties'}[0]{'InChI'} ) {
	    		$inchi = $temp_scalar->{'PropertyTable'}{'Properties'}[0]{'InChI'} ;
	    	}
	    	else {
	    		carp "The following scalar structure from read_inchi_from_json doesn't exist\n" ;
	    	}
	    }
	    else {
	    	carp "The current \"cid\" doesn't return any inchi\n" ;
	    }
    }
    return(\$inchi) ;
}
## END of SUB

=head2 METHOD read_inchikey_from_json

	## Description : read any list of inchi in a json format_from a _unik_id
	## Input : $json_text
	## Output : $inchikey
	## Usage : my ( $inchikey ) = read_inchikey_from_json( $json_text ) ;
	
=cut
## START of SUB
sub read_inchikey_from_json {
	## Retrieve Values
    my $self = shift ;
    my ( $json_text ) = @_ ;
    
    my $inchikey = undef ;
    my $temp_scalar = undef ;
    
    if ( defined $json_text ) {
    	$temp_scalar = decode_json $json_text ;
    	
    	if ( defined $temp_scalar ) {
	    	if ( exists $temp_scalar->{'PropertyTable'}{'Properties'}[0]{'InChIKey'} ) {
	    		$inchikey = $temp_scalar->{'PropertyTable'}{'Properties'}[0]{'InChIKey'} ;
	    	}
	    	else {
	    		carp "The following scalar structure from read_inchikey_from_json doesn't exist\n" ;
	    	}
	    }
	    else {
	    	carp "The current \"cid\" doesn't return any inchikey\n" ;
	    }
    }
    return(\$inchikey) ;
}
## END of SUB

=head2 METHOD read_isomeric_smiles_from_json

	## Description : read any list of isomeric smiles in a json format from a unik id.
	## Input : $json_text
	## Output : $iso_smiles
	## Usage : my ( $iso_smiles ) = read_isomeric_smiles_from_json( $json_text ) ;
	
=cut
## START of SUB
sub read_isomeric_smiles_from_json {
	## Retrieve Values
    my $self = shift ;
    my ( $json_text ) = @_ ;
    
    my $iso_smiles = () ;
    my $temp_scalar = undef ;
    
    if ( defined $json_text ) {
    	$temp_scalar = decode_json $json_text ;
    	
    	if ( defined $temp_scalar ) {
	    	if ( exists $temp_scalar->{'PropertyTable'}{'Properties'}[0]{'IsomericSMILES'} ) {
	    		$iso_smiles = $temp_scalar->{'PropertyTable'}{'Properties'}[0]{'IsomericSMILES'} ;
	    	}
	    	else {
	    		carp "The following scalar structure from read_isomeric_smiles_from_json doesn't exist\n" ;
	    	}
	    }
	    else {
	    	carp "The current \"cid\" doesn't return any isomeric smiles\n" ;
	    }
    }
    return(\$iso_smiles) ;
}
## END of SUB

=head2 METHOD read_canonical_smiles_from_json

	## Description : read any list of canonical smiles in a json format from a unik id.
	## Input : $json_text
	## Output : $can_smiles
	## Usage : my ( $can_smiles ) = read_canonical_smiles_from_json( $json_text ) ;
	
=cut
## START of SUB
sub read_canonical_smiles_from_json {
	## Retrieve Values
    my $self = shift ;
    my ( $json_text ) = @_ ;
    
    my $can_smiles = () ;
    my $temp_scalar = undef ;
    
    if ( defined $json_text ) {
    	$temp_scalar = decode_json $json_text ;
    	
    	if ( defined $temp_scalar ) {
	    	if ( exists $temp_scalar->{'PropertyTable'}{'Properties'}[0]{'CanonicalSMILES'} ) {
	    		$can_smiles = $temp_scalar->{'PropertyTable'}{'Properties'}[0]{'CanonicalSMILES'} ;
	    	}
	    	else {
	    		carp "The following scalar structure from read_canonical_smiles_from_json doesn't exist\n" ;
	    	}
	    }
	    else {
	    	carp "The current \"cid\" doesn't return any canonical smiles\n" ;
	    }
    }
    return(\$can_smiles) ;
}
## END of SUB

=head2 METHOD read_ids_from_json

	## Description : read a list of ids contained in a json handler
	## Input : $json_text
	## Output : $ids
	## Usage : my ( $ids ) = read_ids_from_json( $json_text ) ;
	
=cut
## START of SUB
sub read_ids_from_json {
	## Retrieve Values
    my $self = shift ;
    my ( $json_text ) = @_ ;
    
    my @ids = () ;
    my $temp_scalar = undef ;
    
    if ( defined $json_text ) {
    	$temp_scalar = decode_json $json_text ;
    	if ( defined $temp_scalar ) {
	    	if ( exists $temp_scalar->{'IdentifierList'}{'CID'} ) {
	    		@ids = @{$temp_scalar->{'IdentifierList'}{'CID'}} ;
	    		if ($ids[0] == 0 ) { @ids = () ; } ## manage case with no response !
	    	}
	    	else {
	    		carp "The following scalar structure from read_ids_from_json doesn't exist\n" ;
	    	}
	    }
	    else {
	    	carp "The current \"smiles\" structure doesn't return any ids\n" ;
	    }
    }
    return(\@ids) ;
}
## END of SUB

=head2 METHOD read_names_from_json

	## Description : read a list of ids contained in a json handler
	## Input : $json_text
	## Output : $names
	## Usage : my ( $names ) = read_names_from_json( $json_text ) ;
	
=cut
## START of SUB
sub read_names_from_json {
	## Retrieve Values
    my $self = shift ;
    my ( $json_text ) = @_ ;
    
    my @names = () ;
    my $temp_scalar = undef ;
    
    if ( defined $json_text ) {
    	$temp_scalar = decode_json $json_text ;
    	
    	print Dumper $temp_scalar ;
    	
    	if ( defined $temp_scalar ) {
	    	if ( exists $temp_scalar->{'InformationList'}{'Information'}[0]{'Synonym'} ) {
	    		@names = @{$temp_scalar->{'InformationList'}{'Information'}[0]{'Synonym'}} ;
	    	}
	    	else {
	    		carp "The following scalar structure from read_names_from_json doesn't exist\n" ;
	    	}
	    }
	    else {
	    	carp "The current \"cid\" doesn't return any names" ;
	    }
    }
    return(\@names) ;
}
## END of SUB

## -----------------------  decode and read XML output ------------------- ## 
# In progress... but not at this time...
     


1 ;

__END__

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc bank::ws_pubchem.pm

=head1 Exports

=over 4

=item :ALL is get_ids_from_smiles get_ids_from_common_name get_names_from_cid get_isomeric_smiles_from_cid get_canonical_smiles_from_cid get_inchi_from_cid

=back

=head1 AUTHOR

Franck Giacomoni E<lt>franck.giacomoni@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : 29 / 07 / 2013

version 2 : ??

=cut