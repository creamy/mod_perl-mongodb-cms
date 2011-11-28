package Response;

use strict;
use warnings;

use Layout;
use DB;
use Cookie;
use Auth;
use Req;
use Apache2::RequestRec;
use Apache2::RequestIO;
use Apache2::RequestUtil;

use Apache2::Const -compile => 'OK';

sub handler {
	my $r = shift;

	my $authenticated = undef;
        my $auth = eval { new Auth(); } or die ($@);
	my $cookie_p = eval { new Cookie(); };
	my %cookies = $cookie_p->get_cookies();

        if (exists $cookies{foo}) {
		$authenticated = $auth->accountid($cookies{foo});
	}
	
	$r->content_type('text/html');

	my $html = eval { new Layout(); } or die ($@);
	$html->filename('/www/web_root/ui/layout.html');
	$html->content('');

        my $req_p = eval { new Req(); };
        my %req = $req_p->parse($r->filename,$r->path_info);
	$html->append($req{content});

	$r->print ($html->process());
	return Apache2::Const::OK;
}

1;
