#class Layout
package Layout;
use strict;

#constructor
sub new {
	my ($class) = @_;
	my $self = { 
		_filename => undef,
		_content => undef
	};
	bless $self, $class;
	return $self;
}

sub filename {
	my ( $self, $filename ) = @_;
	$self->{_filename} = $filename if defined($filename);
	return $self->{_filename};
}

sub content {
	my ( $self, $content ) = @_;
	$self->{_content} = $content if defined($content);
	return $self->{_content};
}

sub append {
	my ($self,$append) = @_;
	$self->{_content} = $self->{_content}.$append;
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
