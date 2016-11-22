package _tk ;

## Module permettant de designer l'environnement Tk utilisé dans les scripts interface PERL
## Proprieté INRA -- PFEM -- F Giacomoni

use strict ;
use warnings ;
use Data::Dumper ;

use Tk ;
use Tk::JComboBox ;
use Tk::Menubutton ;
use Tk::Radiobutton ;
use Tk::Text ;
use Tk::Scrollbar ;
use Tk::ProgressBar ;




## Fonction creation de la fenetre courante avec sous menu
## Input = $windows, $size_x, $size_y, $title, @CmdList
## Output = objet windows
sub MainWindowsAvecMenu{
	## Retrieve value :
	my ($windows, $size_x, $size_y, $title, $ref_HashCmdList) = @_ ;
	
	## Private variables
	my $GlobalFont = '{Garamond} 10' ;
	my @CmdList = () ;
	$windows->minsize($size_x, $size_y) ;
	$windows->title($title) ; 	##Définition du title de la fenêtre
	
	my $barre_menu = $windows->Frame(-relief => 'groove' , -borderwidth => 2) ; ## Definition de la barre de menu de la fenetre principale
	
	#Création de la barre du menu général
	while( my ($k, $v) = each %$ref_HashCmdList ) {
		push (@CmdList, my $ItemOption = ['command' => $k, -font => $GlobalFont, -command => $v ] ) ;
	}
	my $menu_app = $barre_menu->Menubutton	( -text => 'Application', -font => $GlobalFont,	-tearoff => 0, -menuitems => \@CmdList );	
	
	$menu_app->pack(-side => 'left') ; ## Affichage du menu général à gauche
	$barre_menu->pack(-side => 'top', -anchor => 'n', -fill => 'x') ;#Affichage de la barre de menu ancrée en haut et sur toute la largeur de la fenêtre
	
	return ($windows) ;
}
### END of SUB

## Fonction de creation d'une frame &Frame_simple
## Input = $windows, $label, $relief, $bordure, $expand, $fill, $side
## Output = objet $frame
sub Frame_simple{
	## Retrieve values
	my ($windows, $label, $relief, $bordure, $expand, $fill, $side, $xpad) = @_ ;
	
	my $frame= $windows	->Frame( -relief => $relief, -bd => $bordure, -label => $label )
						->pack(-expand => $expand, -fill => $fill, -side => $side, -padx => $xpad ) ;
	return ($frame) ;
}
### END of SUB

## Fonction :
## Input :
## Ouput :
sub LabelFrame_simple {
	## Retrieve values
    my ( $windows, $text, $relief, $bordure, $expand, $fill, $side, $xpad ) = @_;
    
    my $LabelFrame = $windows 	-> Labelframe( -relief => $relief, -borderwidth => $bordure, -text => $text )
    							-> pack (-expand => $expand, -fill => $fill, -side => $side, -padx => $xpad ) ;
    
    return ( $LabelFrame ) ;
}
### END of SUB

## Fonction creation de label simple pour la fenetre courante => input parameters &label_simple($windows, $text, $xpad, $side)
## Input :
## Output :
sub Label_simple{
	##retrieve value
	my ($windows, $text, $xpad, $side) = @_ ;
	
	my $label_simple = $windows	->Label(-text =>  $text, -font => '{Arial} 8', -takefocus => 1)
								->pack(-side => $side, -padx => $xpad) ;
	return($label_simple) ;
}
### END of SUB

## Fonction creation de Entry simple pour la fenetre courante
## Input = $windows, $hash_ref, $TypeRef, $Width
## Output = objet widget
sub Entry_simple{
	# retrieve value
	my ($windows, $hash_ref, $TypeRef, $Width, $xpad, $side) = @_ ;
	
	my $Entry_simple = $windows	-> Entry ( -background => 'white',	-textvariable => \$hash_ref->{$TypeRef}, -width => $Width, -takefocus => 1)
								->pack(-side => $side, -padx => $xpad) ;
	return($Entry_simple) ;
}
### END of SUB

## Fonction creation de radio bouton avec commande
## Input : $windows, $text, $value, $hash_ref, $TypeRef, $xpad, $side, $cmd
## Output :
sub RadioButtonWithCmd{
	##retrieve value
	my ($windows, $text, $value, $hash_ref, $TypeRef, $xpad, $side, $cmd) = @_ ;
	## creation du radio bouton avec text, valeur, position x et y
	my $RadioButtonWithCmd = $windows	->Radiobutton (-text => $text, -value => $value, -variable => \$hash_ref->{$TypeRef}, -command => $cmd)
										->pack (-side => $side, -padx => $xpad) ;
	return($RadioButtonWithCmd) ;
}
### END of SUB

## Fonction bouton avec cmd &bouton_avec_fonction($windows, $text, $command, $width, $xpad, $side)
## Input = $windows, $text, $command, $width, $xpad, $side
## Output = objet Bouton
sub Bouton_avec_fonction {
	##retrieve value
	my ($windows, $text, $command, $width, $xpad, $side) = @_ ;
	
	## creation du bouton avec text, reference de la fonction, valeur, position x et y
	my $bouton = $windows 	->Button(-text => $text, -command =>$command, -width => $width)
							->pack(-side => $side, -padx => $xpad) ;
	return($bouton) ;
}
### END of SUB

## Fonction de creation de combobox sans cmd associées
## Input : $windows, $Item, $ItemValue, $variable, $entryWidth, $listWidth, $xplace, $yplace
## Output : objet ComboBox
sub JComboBoxSimple {
	##retrieve value
	my ($windows, $List_ref, $entryWidth, $listWidth, $xpad, $side, $hash_ref, $TypeRef ) = @_ ;
	
	## Creation de la combobox avec input parameters
	my $JComboBoxSimple = $windows	->	JComboBox	(	-entrybackground => 'white',
														-mode => 'editable',
														-relief => 'sunken',
														-entrywidth => $entryWidth,
														-listwidth => $listWidth,
														-textvariable => \$hash_ref->{$TypeRef},
														-takefocus => 1)
									->pack(-side => $side, -padx => $xpad) ;
	return ($JComboBoxSimple) ;
}
### END of SUB

## Fonction warning popup  &PopUp_simple($width, $title, $text, $cmd )
## Input :
## Output :
sub PopUp_simple {
	my ($width, $title, $text, $cmd ) = @_ ;
	my $Popup_simple = MainWindow->new ;
	$Popup_simple->geometry($width) ;
	$Popup_simple->title($title) ;
	my $FramePopUp = Frame_simple($Popup_simple, undef, "groove", 2, 1, 'both', 'top', 10 ) ;
	&Label_simple($FramePopUp, $text, 10, 'top') ;
	&Bouton_avec_fonction($FramePopUp, 'Fermer', $cmd, 10, 20, 'bottom') ;
	&CentrerWidget($Popup_simple) ;
	
	return($Popup_simple) ;
}
### END of SUB

## Fonction warning popup  &PopUp_simple($width, $title, $text, $cmd )
## Input :
## Output :
sub PopUp_warning {
	my ($width, $title, $text ) = @_ ;
	my $Popup_simple = MainWindow->new ;
	$Popup_simple->geometry($width) ;
	$Popup_simple->title($title) ;
	my $FramePopUp = Frame_simple($Popup_simple, undef, "groove", 2, 1, 'both', 'top', 10 ) ;
	&Label_simple($FramePopUp, $text, 10, 'top') ;
	&CentrerWidget($Popup_simple) ;
	
	return($Popup_simple) ;
}
### END of SUB

## Fonction permettant de centrer une fenetre Tk sur l'ecran
## Input :
## Output :
sub CentrerWidget {
	
	unless ( scalar(@_) == 1 ) { die('Usage : CentrerWidget( $MainWidget );'); }
	
	my ( $Widget ) = @_;

	# Height and width of the screen
	my $LargeurEcran = $Widget->screenwidth();
	my $HauteurEcran = $Widget->screenheight();

	# update le widget pour recuperer les vraies dimensions
	$Widget->update;
	my $LargeurWidget = $Widget->width;
	my $HauteurWidget = $Widget->height;

	# On centre le widget en fonction de la taille de l'ecran
	my $NouvelleLargeur  = int( ( $LargeurEcran - $LargeurWidget ) / 2 );
	my $NouvelleHauteur  = int( ( $HauteurEcran - $HauteurWidget ) / 2 );
	$Widget->geometry($LargeurWidget . "x" . $HauteurWidget 
	. "+$NouvelleLargeur+$NouvelleHauteur");

	$Widget->update;

	return ($Widget);
}
### END of SUB

## Fonction :
## Input :
## Ouput :
sub FermerWidget {
    ## Retrieve Values
    my ( $refH_Widget, $att_name ) = @_;
    
    $refH_Widget->{$att_name}->destroy() ;
    
    return ;
}
### END of SUB

## Fonction pour fermer et quitter l'application 
## Input = none
## Output = 0
sub QuitterSimple{
	exit(0) ;
}
### END of SUB




1 ;