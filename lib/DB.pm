#class DB
package DB;
use strict;
use MongoDB;
use MongoDB::OID;

#constructor
sub new {
        my ($class) = @_;
        my $self = {
                _dbh => undef
        };
        bless $self, $class;
        return $self;
}

sub connect {
        my ($self) = @_;
	my $conn = MongoDB::Connection->new;
	my $dbh = $conn->CMSDB;
	$self->{_dbh} = $dbh;
        return $self->{_dbh};
}
1;
