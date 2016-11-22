package formats::mol ;

use strict;
use warnings ;
use Exporter ;
use Carp ;

use Data::Dumper ;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

our $VERSION = "1.0";
our @ISA = qw(Exporter);
our @EXPORT = qw( write_mol_file validate_mol_file );
our %EXPORT_TAGS = ( ALL => [qw( write_mol_file validate_mol_file)] );

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
     
=head2 METHOD write_mol_file

	## Description : permet de produire un mol file à partie d'un scalar
	## Input : $omol, $mol_file
	## Output : $mol_file
	## Usage : my ( $mol_file ) = write_mol_file( $omol, $mol_file ) ;
	
=cut
## START of SUB
sub write_mol_file {
	## Retrieve Values
    my $self = shift ;
    my ( $omol, $mol_file ) = @_ ;
    
    if (defined $omol) {
    	
    	open (MOL, ">$mol_file") or die "can't create the asked mol file\n" ;
    	print MOL "$omol" ;
    	close(MOL) ;
    	
    	if (-z $mol_file) {
    		croak "The created mol file ($mol_file) is empty\n" ;
    	}
    }
    return($mol_file) ;
}
## END of SUB

=head2 METHOD validate_mol_file

	## Description : permet de valider la structure du mol file selon les criteres V2000
	## Input : $mol_file
	## Output : $mol_file, $eval
	## Usage : my ( $mol_file ) = validate_mol_file( $mol_file ) ;
	
=cut
## START of SUB
sub validate_mol_file {
	## Retrieve Values
    my $self = shift ;
    my ( $mol_file ) = @_ ;
    
    my $eval = undef ;
	my ( $nb_line, $ctab_lines, $ctab, $v_standard, $m_end ) = (1, 0, 0, undef, 0) ;
	open(MOL, "<$mol_file") or die "Cant' read the file $mol_file\n" ;
	while (<MOL>){
		chomp $_ ;
		if ($nb_line == 4) { ##  Counts line: 6 atoms, 6 bonds, ..., V2000 standard
			
			if ($_ !~/(.*)V2000$/) { $v_standard = 1 ; }
			if ($_ =~/(\d+)  (\d+)  (\d+)  (\d+)  (\d+)  (\d+)  (\d+)  (\d+)  (\d+)  (\d+)  (\d+) V2000/) {
				my ( $atoms, $bonds ) = ( $1, $2 ) ;
				$ctab = $atoms + $bonds ;
			}
		}
		elsif ($nb_line > 4) { ## check size of Connection table
			if ($_ !~/^(M\s+END)/) { $ctab_lines++ ;  }
			elsif ($_ =~/^(M\s+END)/) { $m_end = 1 ; }
			
		}
		$nb_line++ ;
	}
	close(MOL) ; 
	
	if ( $ctab_lines != $ctab ) { croak "The mol file is hard corrupted : the connection table size is not validated\n" ; }
	if ( defined $v_standard ) { croak "The mol file is hard corrupted : the version is not V2000\n" ; }
	if ( !defined $m_end ) { warn "The mol file is low corrupted : The \"M END\" tag is missing\n" ; }
    
    return() ;
}
## END of SUB


1 ;


__END__

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc formats::mol.pm

=head1 Exports

=over 4

=item :ALL is ...

=back

=head1 AUTHOR

Franck Giacomoni E<lt>franck.giacomoni@clermont.inra.frE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 VERSION

version 1 : 31 / 05 / 2013

version 2 : ??

=cut