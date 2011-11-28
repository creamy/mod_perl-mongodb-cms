#class Cookie
package Cookie;
use strict;

#constructor
sub new {
        my ($class) = @_;
        my $self = {
        };
        bless $self, $class;
        return $self;
}

sub get_cookies {
	map { split /=/, $_, 2 } split /; /, $ENV{'HTTP_COOKIE'} ;
}

1;
