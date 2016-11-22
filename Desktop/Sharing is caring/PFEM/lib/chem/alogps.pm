package chem::alogps ;

use strict;
use warnings ;
use Exporter ;
use Carp ;

use Data::Dumper ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw( get_logp );
our %EXPORT_TAGS = ( ALL => [qw( get_logp )] );


# loading libraries needed to ALOGPS 2.1 algorithm
our $Classpath = 
	'lib;
	lib\\options.jar;
	lib\\axis-ant.jar;
	lib\\axis-schema.jar;
	lib\\axis.jar;
	lib\\commons-discovery-0.2.jar;
	lib\\commons-logging-1.0.4.jar;
	lib\\jaxrpc.jar;
	lib\\log4j-1.2.8.jar;
	lib\\saaj.jar;
	lib\\wsdl4j-1.5.1.jar;
	lib\\mail.jar;
	lib\\activation.jar'
;

=head1 NAME

chem::alogps - A module for managing AlogPS Web service (JAVA version)

=head1 SYNOPSIS

    use chem::alogps ;
    my $object = chem::alogps->new();
    print $object->as_string;

=head1 DESCRIPTION

Perl module using the algorithm ALOGPS 2.1 implemented by 
Virtual Computational Chemistry Laboratory : http://www.vcclab.org/lab/alogps/
to generate a prediction of LogP and LogD of a molecule structure given from the 
MOL format
Author: Daniel Cesaire 
Email : cesaire.daniel@clermont.inra.fr
Version: 1.0
Created: 05/07/2011
Modified 12/06/2013 (Franck Giacomoni)

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

=head2 METHOD get_logp

	## Description : permet de calculer le logp d'une molecule au format mol
	## Input : $mol
	## Output : $logp
	## Usage : my ( $logp ) = get_logp( $mol ) ;
	
=cut
## START of SUB
sub get_logp {
	## Retrieve Values
    my $self = shift ;
    my ( $mol ) = @_ ;
    
    my ( $logp, $xml ) = (undef, undef) ;
    
    if ($mol){
		$xml = `java -classpath $Classpath VcclabALOGPS -f mol $mol`;
		if ( $xml ) {
			$logp = _get_result_from_xml($xml, 'logp') ;
		}
	}
	else {
		croak "the mol file is not defined\n" ;
	}
    
    
    return($logp) ;
}
## END of SUB
     


=head2 PRIVATE METHOD _get_result_from_xml

	## Description : permet de parser la sortie xml de alogps et de renvoyer la data demandée
	## Input : $xml, $type
	## Output : $data
	## Usage : my ( $data ) = _get_result_from_xml( $xml, $type ) ;
	
=cut
## START of SUB
sub _get_result_from_xml {
	## Retrieve Values
    my ( $xml, $type ) = @_ ;
    
    my $data = undef ;
    
    if ( ( $xml ) and ( $type ) ) {
    	
    	my $handler = {'MOLECULE' => 
    		sub {
				if ($type eq 'logp') {
					$data = $_->field('LOGP') ;
				}
				elsif ($type eq 'logs') {
					$data = $_->field('LOGS') ;
				}
				elsif ($type eq 'solubility') {
					$data = $_->field('SOLUBILITY') ;
				}
    		}
    	} ;
    	
    	my $otwig =  new XML::Twig( pretty_print => 'indented', output_filter=>'safe', keep_atts_order => 1, TwigHandlers => $handler);
		## Parcours du twig et application du handler	
		$otwig->parsefile($xml) ;
		$otwig->purge ;
    	
    }
    
    return($data) ;
}
## END of SUB


1 ;


__END__

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc alogps.pm

=head1 Exports

=over 4

=item :ALL is ...

=back

=head1 AUTHOR

Daniel Cesaire E<lt>daniel.cesaire@clermont.inra.frE<gt>
Franck Giacomoni E<lt>franck.giacomoni@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : 05 / 07 / 2011

version 2 : 12 / 06 / 2013

=cut