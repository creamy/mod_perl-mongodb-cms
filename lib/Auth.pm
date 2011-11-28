#class Auth
package Auth;
use strict;
use DB;

#constructor
sub new {
        my ($class) = @_;
        my $self = {
			_accountid => undef,
			_god => undef,
			_authenticated => undef
        };
        bless $self, $class;
        return $self;
}

sub accountid {
        my ( $self,$accountid ) = @_;
		if (defined ($self->{_accountid})) {
			return $self->{_authenticated}
		} else {
			my $is_authenticated=undef;
			my $db = eval { new DB(); } or die ($@);
			my $conn = $db->connect();
			my $sth = $conn->prepare("SELECT * FROM accounts WHERE status='Y' AND accountid='$accountid'");
			$sth->execute();
			my $numRows = $sth->rows;
			if ($numRows>0) {
				$self->{_authenticated} = 1;
				$is_authenticated = 1;
			} else {
				$self->{_authenticated}=undef;
			}
			return $is_authenticated;
		}		
}

1;
