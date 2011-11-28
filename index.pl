#!/usr/local/perl5142/bin/perl

use Layout;
use Apache2::RequestRec;
use Apache2::RequestUtil;

my $r = Apache2::RequestUtil->request;
$r->content_type('text/html');

my $html = eval { new Layout(); } or die ($@);
$html->filename('/www/web_root/ui/layout.html');
$html->content('<h1>Site Maintenance Status.</h1>');
$html->append('<p>The site is under maintenance. Come back later.</p>');
$r->print ($html->process());

