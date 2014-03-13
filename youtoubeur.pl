use strict;
use utf8;
use Gtk2;

Gtk2->init;

my $window = Gtk2::Window->new();

sub delete_event
{
	Gtk2->main_quit;
	return 0;
}

sub destroy {
    my ($self, $response) = @_;
    $self->destroy;
}




$window->set_title("Youtoubeur");
$window->signal_connect(delete_event => "delete_event");
$window->show;
my $mainbox=Gtk2::VBox->new();


my $button=Gtk2::Button->new_from_stock("gtk-ok");

my $urlbox=Gtk2::HBox->new();
my $label=Gtk2::Label->new("URL :");
$label->show;
$urlbox->add($label);
my $entry = Gtk2::Entry->new();
$urlbox->add($entry);



my $folderbox=Gtk2::HBox->new();
my $label=Gtk2::Label->new("Destination :");
$label->show;
$folderbox->add($label);
my $filechooser=Gtk2::FileChooserButton->new ("filechooser", "select-folder");
$folderbox->add($filechooser);

$mainbox->add($urlbox);
$mainbox->add($folderbox);
$mainbox->add($button);
$window->add($mainbox);
$window->show_all();


sub download {
    my $dialog;
    my $url=$entry->get_text();
    if ($url eq "") {
        $dialog = Gtk2::MessageDialog->new ($window, 'modal', 'error', 'close', "L'URL est vide !"); 
    } else {
        $button->set_label("Téléchargement en cours...");
        Gtk2->main_iteration;
        my $path=$filechooser->get_current_folder();
        my $result = qx/.\/youtube-dl -o "${path}\/%(title)s.%(ext)s" "$url" 2>&1/;
        if ($?>0) {
            $dialog = Gtk2::MessageDialog->new ($window, 'modal', 'error', 'close', $result);
        } else {
            my $result = qx/youtube-dl -e "$url" 2>&1/;
            $dialog = Gtk2::MessageDialog->new ($window, 'modal', 'info', 'close', "Fini de télécharger\n".$result);
        }
        $button->set_label("gtk-ok");
    }
    $dialog->show;
    $dialog->signal_connect(response => "destroy");
}

$button->signal_connect(clicked => "download");


Gtk2->main;
