package xml::write_xml ;

use strict;
use warnings ;
use Exporter ;
use Carp ;

use Data::Dumper ;

use XML::Writer ;
use IO::File ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw( write_utf8_xml);
our %EXPORT_TAGS = ( ALL => [qw( write_utf8_xml)] );

=head1 NAME

My::Module - An example module

=head1 SYNOPSIS

    use xml::write_xml ;
    my $object = xml::write_xml->new();
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
    my $self={} ;
    bless($self) ;
    return $self ;
}
### END of SUB

=head2 METHOD write_utf8_xml

	## Description : permet d'écrire un fichier xml à partir d'un hash de hash
	## Input : $xml_name, $features, $root, $elt
	## Output : $xml_file
	## Usage : my ( $xml_file ) = write_utf8_xml( $xml_name, $features, $root, $elt ) ;
	
=cut
## START of SUB
sub write_utf8_xml {
	## Retrieve Values
    my $self = shift ;
    my ( $xml_name, $features, $root, $elt ) = @_ ;
    
    my $output = new IO::File(">$xml_name");
    my $writer = new XML::Writer(
	    OUTPUT      => $output,
	    DATA_INDENT => 3,             # indentation, trois espaces
	    DATA_MODE   => 1,             # changement ligne.
	    ENCODING    => 'utf-8',
	);
	
	$writer->xmlDecl("UTF-8");
	$writer->startTag("$root");
	foreach my $id (sort {$a<=>$b} (keys %{$features}) ) {
		$writer->startTag("$elt", id => $id );
		
		my %temp = %{ $features->{$id} } ;
		
		foreach my $feature (keys (%temp)) {
			
			if ($feature eq 'name') {
				$writer->characters($temp{$feature});
			}
		}
		$writer->endTag("$elt") ;
	}
    $writer->endTag("$root");
	$writer->end();
	$output->close();
    
    return($xml_name) ;
}
## END of SUB

=head2 METHOD write_3levels_utf8_xml

	## Description : permet d'écrire un fichier xml à partir d'un hash de hash de hash
	## Input : $xml_name, $features, $root, $elt1, $elt2, $elt3
	## Output : $xml_file
	## Usage : my ( $xml_file ) = write_3levels_utf8_xml( $xml_name, $features, $root, $elt1, $elt2, $elt3 ) ;
	
=cut
## START of SUB
sub write_3levels_utf8_xml {
	## Retrieve Values
    my $self = shift ;
    my ( $xml_name, $features, $root1, $elt1, $field1, $root2, $elt2, $field2, $root3, $elt3, $field3 ) = @_ ;
    
    my $output = new IO::File(">$xml_name");
    my $writer = new XML::Writer(
	    OUTPUT      => $output,
	    DATA_INDENT => 3,             # indentation, trois espaces
	    UNSAFE		=> 1,			  # UNSAFE mode true = skip most well-formedness error checking
	    DATA_MODE   => 1,             # changement ligne.
	    ENCODING    => 'utf-8',
	);
	
	$writer->xmlDecl("UTF-8");
	$writer->startTag("$root1");
	
	## foreach HASH
	foreach my $id1 (sort {$a<=>$b} (keys %{$features}) ) {
		$writer->startTag("$elt1", id => $id1 );
		if ( exists $features->{$id1}{$field1} ) { 	$writer->characters($features->{$id1}{$field1} ); }
		if ( $features->{$id1}{$root2} ) {
			my %temp_elt2 = %{ $features->{$id1}{$root2} } ;
			$writer->startTag("$root2" );
			
			## foreach HASH of HASH
			foreach my $id2 (sort {$a<=>$b} (keys %temp_elt2 ) ) {
				$writer->startTag("$elt2", id => $id2 );
				if ( exists $temp_elt2{$id2}{$field2} ) { $writer->characters($temp_elt2{$id2}{$field2} ); 	}
				if ( $features->{$id1}{$root2}{$id2}{$root3} ) {
					my %temp_elt3 = %{ $features->{$id1}{$root2}{$id2}{$root3} } ;
					$writer->startTag("$root3" );
				
					## foreach HASH of HASH of HASH
					foreach my $id3 (sort {$a<=>$b} (keys %temp_elt3 ) ) {
						$writer->startTag("$elt3", id => $id3 );
						if ( exists $temp_elt3{$id3}{$field3} ) { $writer->characters($temp_elt3{$id3}{$field3} ); 	}
						$writer->endTag("$elt3") ;
					}
					$writer->endTag("$root3");
				} ## END IF
				$writer->endTag("$elt2") ;
				
			}## END foreach HASH of HASH
			$writer->endTag("$root2");
		} ## END IF
		$writer->endTag("$elt1") ;
		
	}## END foreach HASH
	$writer->endTag("$root1");
	$writer->end();
	$output->close();
    
    
    return($xml_name) ;
}
## END of SUB
     


1 ;


__END__

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc write_xml.pm

=head1 Exports

=over 4

=item :ALL is ...

=back

=head1 AUTHOR

Franck Giacomoni E<lt>franck.giacomoni@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : 14 / 05 / 2013

version 2 : ??

=cut