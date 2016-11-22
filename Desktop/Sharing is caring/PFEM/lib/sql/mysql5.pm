package sql::mysql5 ;

use strict;
use warnings ;
use Exporter ;
use Carp ;

use Data::Dumper ;

use DBI ;
use DBD::mysql ;
use Encode ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw( );
our %EXPORT_TAGS = ( ALL => [qw(  )] );

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
     
=head2 METHOD connect_to_mysql5

	## Description : permet d'ouvrir une connexion vers une db mysql5 via dbi
	## Input : $host, $db, $user, $password
	## Output : $dbh
	## Usage : my ( $dbh ) = connect_to_mysql5( $host, $db, $user, $password ) ;
	
=cut
## START of SUB
sub connect_to_mysql5 {
	## Retrieve Values
    my $self = shift ;
    my ( $host, $db, $user, $password ) = @_ ;
    
#    print "INTERNAL WARM *** Start Function :: connect_to_mysql5 $db, $host, $user \n"  ;
	
	## Connection to the db on phenomenep project with user _w :
#	my $password = '2905;cha' ;
		
	my $dsn = "dbi:mysql:database=".$db.";host=".$host;	
	my $dbh = DBI->connect($dsn, $user, $password );
	
	## Gestion de l'encodage :
	$dbh->{'mysql_enable_utf8'} = 1 ;
	$dbh->do('SET NAMES UTF8') ;
#	$dbh->do('SET CHARACTER UTF8') ;
	
	return ($dbh) ;
}
## END of SUB

=head2 METHOD disconnect_from_mysql5

	## Description : permet de deconnecter le handle vers la bdd mysql5 ciblée
	## Input : $dbh
	## Output : N/A
	## Usage : disconnect_from_mysql5( $dbh ) ;
	
=cut
## START of SUB
sub disconnect_from_mysql5 {
	## Retrieve Values
    my $self = shift ;
    my ( $dbh ) = @_ ;
    
    ## commande de deconnection
	$dbh->disconnect() ;
    
    return() ;
}
## END of SUB

=head2 METHOD check_existing_table

	## Description : permet de verifier l'existance et le remplissage d'une table
	## Input : $dbh, $table
	## Output : $state, $busy
	## Usage : my ( $state, $ ) = check_existing_table( $dbh, $table ) ;
	
=cut
## START of SUB
sub check_existing_table {
	## Retrieve Values
    my $self = shift ;
    my ( $dbh, $table ) = @_ ;
    
    my ( $state, $busy ) = ( undef, undef ) ;
    
    if ( defined $dbh ) {
    	
		if ( ( defined $dbh ) and ( defined $table )  ) {
    		my $sql1 = "SHOW TABLES LIKE '$table'" ;
			my $sth1 = $dbh->prepare( $sql1 ) ;
			if( $sth1->execute() ) { while( my $t = $sth1->fetchrow_array() ) { if( $t =~ /^$table/ ) { $state = 1 ; } } }
			#
			my $sql2 = "SELECT COUNT(*) FROM `$table`" ;
			my $sth2 = $dbh->prepare( $sql2 ) ;
			if( $sth2->execute() ) { while( my @t = $sth2->fetchrow_array() ) { $busy = $t[0] ; } }
			
    	} ## END IF
    	else {
    		croak "No db table is defined\n" ;
    	}
    }
    else {
    	croak "No db handler is defined\n" ;
    }
    return( $state, $busy ) ;
}
## END of SUB

=head2 METHOD check_existing_tables

	## Description : permet de verifier l'existance et le remplissage de n tables
	## Input : $dbh, $tables
	## Output : $state, $busy
	## Usage : my ( $state, $busy ) = check_existing_tables( $dbh, $tables ) ;
	
=cut
## START of SUB
sub check_existing_tables {
	## Retrieve Values
    my $self = shift ;
    my ( $dbh, $tables ) = @_ ;
    
    my ( @states, @busy ) = ( (), () ) ;
    
    if ( defined $dbh ) {
    	
		if ( ( defined $tables )  ) {
			
			foreach my $table (@{$tables}) {
				my $sql1 = "SHOW TABLES LIKE '$table'" ;
				my $sth1 = $dbh->prepare( $sql1 ) ;
				if( $sth1->execute() ) { while( my $t = $sth1->fetchrow_array() ) { if( $t =~ /^$table/ ) { push (@states, 1) ; } } }
				#
				my $sql2 = "SELECT COUNT(*) FROM `$table`" ;
				my $sth2 = $dbh->prepare( $sql2 ) ;
				if( $sth2->execute() ) { while( my @t = $sth2->fetchrow_array() ) { push (@busy, $t[0] ) ; } }
			}
			
    	} ## END IF
    	else {
    		croak "No db table is defined\n" ;
    	}
    }
    else {
    	croak "No db handler is defined\n" ;
    }
    
    return(\@states, \@busy) ;
}
## END of SUB

=head2 METHOD truncate_table

	## Description : permet de vider une table et de remettre l'incrementation des clés à zero
	## Input : $dbh, $table
	## Output : $status
	## Usage : my ( $status ) = truncate_table( $dbh, $table ) ;
	
=cut
## START of SUB
sub truncate_table {
	## Retrieve Values
    my $self = shift ;
    my ( $dbh, $table ) = @_ ;
    
    my $status = undef ;
    
    if ( defined $dbh ) {
    	
		if ( defined $table ) {
    		my $sql1 = "TRUNCATE TABLE `$table`" ;
			my $sth1 = $dbh->prepare( $sql1 ) ;
			$sth1->execute() ;
			
    	} ## END IF
    	else {
    		croak "No db table is defined\n" ;
    	}
    }
    else {
    	croak "No db handler is defined\n" ;
    }
    return() ;
}
## END of SUB

=head2 METHOD truncate_tables

	## Description : permet de vider n tables et de remettre l'incrementation des clés à zero
	## Input : $dbh, $tables
	## Output : $status
	## Usage : my ( $status ) = truncate_tables( $dbh, $tables ) ;
	
=cut
## START of SUB
sub truncate_tables {
	## Retrieve Values
    my $self = shift ;
    my ( $dbh, $tables ) = @_ ;
    
    my $status = undef ;
    
    if ( defined $dbh ) {
		if ( defined $tables ) {
			foreach my $table (@{$tables}) {
	    		my $sql1 = "TRUNCATE TABLE `$table`" ;
				my $sth1 = $dbh->prepare( $sql1 ) ;
				$sth1->execute() ;
			}
			
    	} ## END IF
    	else {
    		croak "No db tables list is defined\n" ;
    	}
    }
    else {
    	croak "No db handler is defined\n" ;
    }
    return() ;
}
## END of SUB

=head2 METHOD create_simple_entry_in_table

	## Description : permet de remplir une table à partir d'un array d'entries
	## Input : $dbh, $table, $entries
	## Output : $ids
	## Usage : my ( $ids ) = create_simple_entry_in_table( $dbh, $table, $entries ) ;
	
=cut
## START of SUB
sub create_simple_entry_in_table {
	## Retrieve Values
    my $self = shift ;
    my ( $dbh, $table, $field, $entry ) = @_ ;
    
    my $id = () ;
    
    if ( (defined $dbh) and (defined $table) and (defined $entry) ) {
    	my $sql1 = "INSERT INTO `$table` ($field) VALUES (\'$entry\')" ;
		my $sth1 = $dbh->prepare( $sql1 ) ;
		$sth1->execute() ;
		if ( defined $sth1->{mysql_insertid} ) { $id = $sth1->{mysql_insertid} ; }
    }
    else {
    	croak "a param for create_simple_entry_in_table is not defined\n" ;
    }
    return($id) ;
}
## END of SUB

=head2 METHOD create_tested_entry_in_table

	## Description : permet de remplir une table avec une entrée que l'on a testee auparavant
	## Input : $dbh, $table, $field, $value
	## Output : $id, $status
	## Usage : my ( $id, $status ) = create_tested_entry_in_table( $dbh, $table, $field, $value ) ;
	
=cut
## START of SUB
sub create_tested_entry_in_table {
	## Retrieve Values
    my $self = shift ;
    my ( $dbh, $table, $field, $value ) = @_ ;
    
    my ($id, $status, @ref) = (undef, undef, () ) ;
    
    if ( ( defined $table ) and (defined $field )  and (defined $value ) ) {
    	my $sql1 = "SELECT id FROM `$table` WHERE `$field` = \'$value\'" ;
    	my $sth1 = $dbh->prepare( $sql1 ) ;
		$sth1->execute() ;
		@ref = $sth1->fetchrow_array() ;
		
		## table1.field1 exists
		if ( @ref ) {
			if ((scalar(@ref) == 1) ) { $id = $ref[0] ; $status = 'old' ; }
			else { $status = 'multiple_ids' ; }
		}
		else { ## table1.field1 does not exist
			my $sql2 = "INSERT INTO `$table` ($field) VALUES (\'$value\')" ;
			my $sth2 = $dbh->prepare( $sql2 ) ;
			$sth2->execute() ;
			if ( ( defined $sth2->{mysql_insertid} ) and ( $sth2->{mysql_insertid} != 0 ) ) {  $id = $sth2->{mysql_insertid} ; }
			$status = 'new' ;
		}
    }
    else {
    	croak "a param for create_tested_entry_in_table is not defined\n" ;
    }
    
    return($id, $status) ;
}
## END of SUB

=head2 METHOD create_linked_entry_in_table

	## Description : permet de remplir une table avec une entrée que l'on a testee auparavant et qui est lier à une autre table par une cle etrangere
	## Input : $dbh, $table, $field, $foreign_field, $value, $foreign_key
	## Output : $id, $status
	## Usage : my ( $id, $status ) = create_tested_entry_in_table( $dbh, $table, $field, $foreign_field, $value, $foreign_key ) ;
	
=cut
## START of SUB
sub create_linked_entry_in_table {
	## Retrieve Values
    my $self = shift ;
    my ( $dbh, $table, $field, $value, $foreign_field, $foreign_key ) = @_ ;
    
    my ($id, $status, @ref) = (undef, undef, () ) ;
    
    if ( ( defined $table ) and (defined $field )  and (defined $value ) ) {
    	my $sql1 = "SELECT id FROM `$table` WHERE `$field` = \'$value\'" ;
    	my $sth1 = $dbh->prepare( $sql1 ) ;
		$sth1->execute() ;
		@ref = $sth1->fetchrow_array() ;
		
		## table1.field1 exists
		if ( @ref ) {
			if ((scalar(@ref) == 1) ) { $id = $ref[0] ; $status = 'old' ; }
			else { $status = 'multiple_ids' ; }
		}
		else { ## table1.field1 does not exist
			my $sql2 = "INSERT INTO `$table` ($field, $foreign_field) VALUES (\'$value\', \'$foreign_key\')" ;
			my $sth2 = $dbh->prepare( $sql2 ) ;
			$sth2->execute() ;
			if ( ( defined $sth2->{mysql_insertid} ) and ( $sth2->{mysql_insertid} != 0 ) ) {  $id = $sth2->{mysql_insertid} ; }
			$status = 'new' ;
		}
    }
    else {
    	croak "a param for create_tested_entry_in_table is not defined\n" ;
    }
    
    return($id, $status) ;
}
## END of SUB

=head2 METHOD create_complex_entry_in_table

	## Description : permet de creer une entree dans une table a plusieurs champs (ex : insert )
	## Input : $dbh, $table, $fields, $values
	## Output : $id, $status
	## Usage : my ( $id, $status ) = create_complex_entry_in_table( $dbh, $table, $fields, $values ) ;
	
=cut
## START of SUB
sub create_complex_entry_in_table {
	## Retrieve Values
    my $self = shift ;
    my ( $dbh, $table, $fields, $values ) = @_ ;
    
    my ($id, $status ) = (undef, undef) ;
    
    if ( ( defined $dbh ) and ( defined $table ) and ( defined $fields ) and ( defined $values )  ) {
    	
    	## prepare sql :
    	my ( $field, $value ) = ( undef, undef ) ;
    	for ( my $i = 0 ; $i < (scalar(@{$fields})) ; $i++ ) {
    	    
    	    if ($i < (scalar(@{$fields}))- 1 ) {
    	    	$field .= $fields->[$i].',' ;
    	    	$value .= "\'".$values->[$i]."\'," ;
    	    }
    	    else {
    	    	$field .= $fields->[$i] ;
    	    	$value .= "\'".$values->[$i]."\'" ;
    	    }
    	}
    	
    	if ( ( defined $field ) and ( defined $value ) ) {
    		my $sql1 = "INSERT INTO `$table` ($field) VALUES ($value)" ;

			my $sth1 = $dbh->prepare( $sql1 ) ;
			if (!$sth1) {die "Error:" . $dbh->errstr . "\n"; }
			if (!$sth1->execute) { die "Error:" . $sth1->errstr . "\n"; }
			if ( defined $sth1->{mysql_insertid} ) { $id = $sth1->{mysql_insertid} ; }
			
			$status = 'new' ;
    	} ## END IF
    	else {
    		croak "the list of fields and their value are missing\n" ;
    	}
    	
    } ## END IF
    else {
    	croak "Some parameters for insert transaction missing\n" ;
    }
    
    return($id, $status) ;
}
## END of SUB

=head2 METHOD alter_complex_entry_in_table

	## Description : permet de creer une entree dans une table a plusieurs champs (ex : insert )
	## Input : $dbh, $table, $id_to_alter, $fields, $values
	## Output : $id, $status
	## Usage : my ( $id, $status ) = alter_complex_entry_in_table( $dbh, $table, $id_to_alter, , $values ) ;
	
=cut
## START of SUB
sub alter_complex_entry_in_table {
	## Retrieve Values
    my $self = shift ;
    my ( $dbh, $table, $id_to_alter, $fields, $values ) = @_ ;
    
    my ($entry_id, $status ) = (undef, undef) ;
    
    if ( ( defined $dbh ) and ( defined $table ) and ( defined $id_to_alter ) and ( defined $fields ) and ( defined $values )  ) {
    	
    	## prepare sql :
    	my ( $fields_and_values ) = ( undef ) ;
    	for ( my $i = 0 ; $i < (scalar(@{$fields})) ; $i++ ) {
    		
    	    if ($i < (scalar(@{$fields}))- 1 ) {
    	    	$fields_and_values .= "`".$fields->[$i]."` = \'".$values->[$i]."\', " ;
    	    }
    	    else {
    	    	$fields_and_values .= "`".$fields->[$i]."` = \'".$values->[$i]."\'" ;
    	    }
    	}
    	
    	if ( defined $fields_and_values ) {
    		my $sql1 = "UPDATE `$table` SET $fields_and_values WHERE `id` = \'$id_to_alter\' " ;    		
			my $sth1 = $dbh->prepare( $sql1 ) ;
			if (!$sth1) {die "Error:" . $dbh->errstr . "\n"; }
			if (!$sth1->execute) { die "Error:" . $sth1->errstr . "\n"; }
			if ( defined $sth1->{mysql_insertid} ) { $entry_id = $sth1->{mysql_insertid} ; }
			
			$status = 'update' ;
    	} ## END IF
    	else {
    		croak "the list of fields and their value are missing\n" ;
    	}
    	
    } ## END IF
    else {
    	croak "Some parameters for update transaction missing\n" ;
    }
    
    return($entry_id, $status) ;
}
## END of SUB

=head2 METHOD create_entry_in_joint_table

	## Description : permet de creer une entree dans une table de jointure avec les 2 id et le created/updated_at
	## Input : $dbh, $table, $fields, $values
	## Output : N/A
	## Usage : create_entry_in_joint_table( $dbh, $table, $fields, $values ) ;
	
=cut
## START of SUB
sub create_entry_in_joint_table {
	## Retrieve Values
    my $self = shift ;
    my ( $dbh, $table, $fields, $values ) = @_ ;
    
    if ( ( defined $dbh ) and ( defined $table ) and ( defined $fields ) and ( defined $values )  ) {
    	
    	## prepare sql :
    	my ( $field, $value ) = ( undef, undef ) ;
		
		for ( my $i = 0 ; $i < (scalar(@{$fields})) ; $i++ ) {
			$field .= $fields->[$i].',' ;
    	    $value .= "\'".$values->[$i]."\'," ;
		}
		$field .= 'created_at, updated_at' ;
		$value .= 'NOW(), NOW()' ;
    	
    	if ( ( defined $field ) and ( defined $value ) ) {
    		my $sql1 = "INSERT INTO `$table` ($field) VALUES ($value)" ;

			my $sth1 = $dbh->prepare( $sql1 ) ;
			if (!$sth1) {die "Error:" . $dbh->errstr . "\n"; }
			if (!$sth1->execute) { die "Error:" . $sth1->errstr . "\n"; }
			
    	} ## END IF
    	else {
    		croak "the list of fields and their value are missing\n" ;
    	}
    } ## END IF
    else {
    	croak "Some parameters for insert transaction missing\n" ;
    }
    return() ;
}
## END of SUB


=head2 METHOD set_datetime_in_table

	## Description : permet de fixer la date dans les champs created_at/updated_at
	## Input : $dbh, $table, $type
	## Output : N/A
	## Usage : set_datetime_in_table( $dbh, $table, $type ) ;
	
=cut
## START of SUB
sub set_datetime_in_table {
	## Retrieve Values
    my $self = shift ;
    my ( $dbh, $table, $id, $type ) = @_ ;
    
    if ( (defined $dbh) and (defined $table) and (defined $type) ) {
    	
    	my $sql = undef ;
    	if ($type eq 'new') { $sql = "UPDATE `$table` SET `created_at` = NOW(), `updated_at` = NOW() WHERE `id` = \'$id\' " ; }
    	elsif ($type eq 'update') { $sql = "UPDATE `$table` SET `updated_at` = NOW() WHERE `id` = \'$id\' " ; }
    	elsif ($type eq 'old') { return() ; } ## do nothing !!
    	else { croak "the type of datetime set is unknown\n" ; }
    	
		my $sth = $dbh->prepare( $sql ) ;
		$sth->execute() ;
    }
    else {
    	croak "a param for create_simple_entry_in_table is not defined\n" ;
    }
    return() ;
}
## END of SUB

=head2 METHOD prepare_data

	## Description : permet de neutraliser les caracteres speciaux de data
	## Input : $data
	## Output : $clean
	## Usage : my ( $clean ) = prepare_data( $data ) ;
	
=cut
## START of SUB
sub prepare_data {
	## Retrieve Values
    my $self = shift ;
    my ( $data ) = @_ ;
    
    if (defined $data) {
    	if ( $data =~ /[\'|\\|\"|,]+/ ) {
	    	## manage special caracteres
	    	$data =~ s/\'/\''/g ;
	    	$data =~ s/\"/\""/g ;
	    	$data =~ s/\\/\\\\/g ;
	    	$data =~ s/\,/\,/g ;
	    }
    }    
    return($data) ;
}
## END of SUB

=head2 METHOD encode_data_in_utf8

	## Description : permet d'encoder une data en utf8
	## Input : $data
	## Output : $encoded
	## Usage : my ( $encoded ) = encode_data_in_utf8( $data ) ;
	
=cut
## START of SUB
sub encode_data_in_utf8 {
	## Retrieve Values
    my $self = shift ;
    my ( $data ) = @_ ;
    
    my $encoded = encode("utf8", $data ) ;
    
    return($encoded) ;
}
## END of SUB

=head2 METHOD select_id_from_field_value_in_table

	## Description : permet de retourne un id unique contenu dans la table et correspondant à la requete WHERE field = value
	## Input : $dbh, $table, $field, $value
	## Output : $id, $status
	## Usage : my ( $id, $status ) = select_id_from_field_value_in_table( $dbh, $table, $field, $value ) ;
	
=cut
## START of SUB
sub select_id_from_field_value_in_table {
	## Retrieve Values
    my $self = shift ;
    my ( $dbh, $table, $field, $value ) = @_ ;
    
    my ($id, $status, @ref) = (undef, undef, () ) ;
    
    if ( ( defined $table ) and (defined $field )  and (defined $value ) ) {
    	my $sql1 = "SELECT id FROM `$table` WHERE `$field` = \'$value\'" ;
    	my $sth1 = $dbh->prepare( $sql1 ) ;
		if (!$sth1) {die "Error:" . $dbh->errstr . "with following query $sql1\n"; }
		if (!$sth1->execute) { die "Error:" . $sth1->errstr . "with following query $sql1\n"; }
		@ref = $sth1->fetchrow_array() ;
		
		## table.field exists and have the wanted value
		if ( @ref ) {
			if ((scalar(@ref) == 1) ) { $id = $ref[0] ; $status = 'unik_id' ; }
			else { $status = 'multiple_ids' ; }
		}
		else { #
			warn "\tNo ref send by an SELECT ID in table : $table - the ref $field = $value doesn't exist\n" ;
		}
    }
    else {
    	croak "a param for select_id_from_field_value_in_table is not defined\n" ;
    }    
    return($id, $status) ;
}
## END of SUB




1 ;


__END__

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc mysql5.pm

=head1 Exports

=over 4

=item :ALL is ...

=back

=head1 AUTHOR

Franck Giacomoni E<lt>franck.giacomoni@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : 13 / 05 / 2013

version 2 : ??

=cut