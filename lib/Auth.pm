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

#todo fetch account info and see if authenticated

		return $is_authenticated;
	}		
}

1;
