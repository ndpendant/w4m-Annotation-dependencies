package bank::ws_massbank ;

use strict;
use warnings ;
use Exporter ;
use Carp ;

use Data::Dumper ;

use LWP::Simple ; ## Lib de protocole HTTP de download
use SOAP::Lite + trace => qw(fault); ## SOAP for web service version 0.67
import SOAP::Data qw(name);

use vars qw($VERSION @ISA @EXPORT_OK %EXPORT_TAGS);

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw( ws_get_record_info write_records_from_infos );
our %EXPORT_TAGS = ( ALL => [qw( ws_get_record_info write_records_from_infos )] );

=head1 NAME

My::Module - An example module

=head1 SYNOPSIS

    use bank::ws_massbank;
    my $object = bank::ws_massbank->new();
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
     

=head2 METHOD ws_get_record_info

	## Description : permet via soap d'acceder au WS Massbank et d'utiliser la methode getRecordInfo proposee
	## Input : $ids
	## Output : $records
	## Usage : my ( $records ) = ws_get_record_info( $ids ) ;
	
=cut
## START of SUB
sub ws_get_record_info {
	## Retrieve Values
    my $self = shift ;
    my ( $ids ) = @_ ;
    
    my @records = () ;
    
    my @query = @{$ids} ;
    my $nb_ids = scalar (@query) ;
    
    if ( $nb_ids > 0 ) {
    	
    	my $osoap = SOAP::Lite -> uri('http://api.massbank')-> proxy('http://www.massbank.jp/api/services/MassBankAPI?wsdl', timeout => 6000 ) ;
		my $method = SOAP::Data->name('getRecordInfo') ->attr({xmlns => 'http://api.massbank'});
		my @params = ( SOAP::Data->name('ids' => @query  ) );
		# Call method
		my $som = $osoap->call($method => @params);
	    ## DETECTING A SOAP FAULT
		if ($som->fault) { 		@records = $som->faultdetail; }
		else {					@records = $som->valueof('//info'); }
    }
    else {
    	carp "Ids list is empty, soap will stop\n" ;
    }
    
    return(\@records) ;
}
## END of SUB

=head2 METHOD write_records_from_infos

	## Description : permet de generer une liste de fichiers massbank à partir d'une liste de records retournee par la methode getrecordinfo
	## Input : $dir, $records, $file_names
	## Output : $files
	## Usage : my ( $files ) = write_records_from_infos( $dir, $records, $file_names ) ;
	
=cut
## START of SUB
sub write_records_from_infos {
	## Retrieve Values
    my $self = shift ;
    my ( $dir, $records ) = @_ ;
    
    my @files = () ;
    
    if ( (defined $dir) and (-d $dir ) ) {
    	
    	my $nb = 0 ;
    	foreach my $rec (@{$records}) {
    		
    		my $name = undef ;
    		my $acc_id = undef ;
    		
    		if ($rec =~ /ACCESSION: (\w+)/) { 	$acc_id = $1 ;    		}
    		else { 				    			$acc_id = "$nb-undef_id" ;	}
    		
    		## les noms des fichiers sont ceux des records (!!)
    		$name = $dir.'\\'.$acc_id.'.txt' ;
    		
    		open(REC, "> $name") or die "Cant' create the file $name\n" ;
    		print REC $rec ;
    		close(REC) ;
    		
    		push (@files, $name) ;
    		$nb++ ;
    	}
    }
    else {
    	carp "The working dir is missing\n" ;
    }
    return(\@files) ;
}
## END of SUB



1 ;


__END__

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc bank::ws_massbank.pm

=head1 Exports

=over 4

=item :ALL is ...

=back

=head1 AUTHOR

Franck Giacomoni E<lt>franck.giacomoni@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : 03 / 07 / 2013

version 2 : ??

=cut