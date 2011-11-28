#class Image
package Image;
use strict;

#constructor
sub new {
        my ($class) = @_;
        my $self = {
                _imageid => undef
        };
        bless $self, $class;
        return $self;
}

sub imageid {
        my ( $self, $imageid ) = @_;
        $self->{_imageid} = $imageid if defined($imageid);
        return $self->{_imageid};
}

sub getThumb() {
        my ($self) = @_;
        my $fn = $self->filename;
        open (FILE,$fn) or die "Can't open $fn $!\n";
        my $layout = do { local $/; <FILE> };
        my $c = $self->content;
        $layout =~ s/\<!--Content--\>/$c/g;
        return $layout;
}

sub getFull() {

}

sub process {
        my ($self) = @_;
        my $fn = $self->filename;
        open (FILE,$fn) or die "Can't open $fn $!\n";
        my $layout = do { local $/; <FILE> };
        my $c = $self->content;
        $layout =~ s/\<!--Content--\>/$c/g;
        return $layout;
}

1;
