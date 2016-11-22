package xml::twig_xml ;

use strict;
use warnings ;
use Exporter ;
use Carp ;

use XML::Twig;

use Data::Dumper ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw( );
our %EXPORT_TAGS = ( ALL => [qw( )] );

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

=head2 METHOD get_twig_from_file

	## Description : permet de lire et charger un file xml en memoire via twig
	## Input : $xml_file
	## Output : $twig
	## Usage : my ( $twig ) = get_twig_from_file( $xml_file ) ;
	
=cut
## START of SUB
sub get_twig_from_file {
	## Retrieve Values
    my $self = shift ;
    my ( $xml_file ) = @_ ;
    
    # --- Parse The XML File --- #
	my $twig = XML::Twig->new( pretty_print => 'indented', output_filter=>'safe', keep_atts_order => 1 ) ; # 
	## Chargement du xml en memoire :
	$twig->parsefile( $xml_file) ;
    
    return($twig) ;
}
## END of SUB
     
=head2 METHOD set_twig_from_handler_and_file

	## Description : permet de modifier un twig par la methode des handlers
	## Input : $xml_file, $handler
	## Output : $twig
	## Usage : my ( $twig ) = set_twig_from_handler_and_file( $xml_file, $handler ) ;
	
=cut
## START of SUB
sub set_twig_from_handler_and_file {
	## Retrieve Values
    my $self = shift ;
    my ( $xml_file, $handler ) = @_ ;
    my $twig = undef ;
    
    if ( ( defined $handler ) and ( -e $xml_file ) ) {
		## Conf du twig
		$twig = new XML::Twig( pretty_print => 'indented', output_filter=>'safe', keep_atts_order => 1, TwigHandlers => $handler);
		## Parcours du twig et application du handler	
		$twig->parsefile($xml_file) ;
#		$twig->purge ;
	}
	else {
		croak "Le fichier Xml à transformer $xml_file n'existe pas ou votre handler est mal conf\n" ;
	}
    return($twig) ;
}
## END of SUB

=head2 METHOD write_file_from_twig

	## Description : permet de generer un fichier xml a partir d'un twig
	## Input : $twig, $xml_file
	## Output : $xml_file
	## Usage : my ( $xml_file ) = write_file_from_twig( $twig, $xml_file ) ;
	
=cut
## START of SUB
sub write_file_from_twig {
	## Retrieve Values
    my $self = shift ;
    my ( $twig, $xml_file ) = @_ ;
    
    if ( ( defined $twig ) and ( defined $xml_file ) and ( -e $xml_file ) ) {
#		$twig->print ;
	    $twig->print_to_file($xml_file) ;
	    $twig->purge ;
    }
    return(0) ;
}
## END of SUB

1 ;


__END__

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc twig_xml.pm

=head1 Exports

=over 4

=item :ALL is ...

=back

=head1 AUTHOR

Franck Giacomoni E<lt>franck.giacomoni@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : 30 / 05 / 2013

version 2 : ??

=cut