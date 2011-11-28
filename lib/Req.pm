#class Req
package Req;
use strict;
use DB;


use constant STATIC_PATH => "/www/web_root/ui/static/";


#constructor
sub new {
        my ($class) = @_;
        my $self = {
		_hash => undef,
		_path => undef,
		_post => undef
        };
        bless $self, $class;
        return $self;
}


sub parse {
	my ( $self, $file, $path ) = @_;
	my $root = pop @{[split m|/|, $file]};
	my %hash = map { split /:/, $_ } split /\//, $path;
	$hash{root} = $root;
	$self->{_hash} = %hash;
	$self->{_path} = $root.$path;
	my $content = '';
	if (defined &{$root}) {
		no strict "refs";
		$content = eval { $self->$root() };
	} else {
		$content = $self->home();
	}

	$hash{content} = $content;	
	return (%hash);
	
}

sub home {
	my ( $self ) = @_;
	my $path = $self->{_path};

        my $db = eval { new DB(); } or die ("no db");
        my $conn = $db->connect();
        my $pages = $conn->pages;
        my $page = $pages->find_one({ path => $path });
	my $content = "";
	if ($page != "") {
		$content = $page->{'content'};
		} else {
		$content = "<h1>Welcome</h1><p>$path</p>";
	}
	$conn->close();
	return ($content);
}

sub new_account {
	my ( $self ) = @_;
        my $fn = STATIC_PATH.'join.html'; 
        open (FILE,$fn) or die "Can't open $fn $!\n";
        my $content = do { local $/; <FILE> };
	return ($content);
}

sub list_accounts {
	my ( $self ) = @_;

	my $db = eval { new DB(); } or die ("no db");
	my $conn = $db->connect();
	my $users = $conn->users;
	my $list = $users->find;

	my $user_list = "<ul>";
	while (my $user = $list->next) {
		$user_list .= "<li>".$user->{'username'}."</li>\n";
	}
	

	my $content = "<h2>Accounts List</h2>\n$user_list\n";


	return ($content);
}

sub req_new_account {
	my ( $self ) = @_;
	my %pf = $self->postfields();
	my @err = ();

	if (length($pf{first_name})<1) {
		push (@err,"<li>Please enter your <strong>first name</strong>.</li>");
	}
	if (length($pf{last_name})<1) {
		push (@err,"<li>Please enter your <strong>last name</strong>.</li>");
	}
	if (length($pf{email})<1) {
		push (@err,"<li>Please enter your <strong>email address</strong>.</li>");
	}
	if (length($pf{phone})<1) {
		push (@err,"<li>Please enter your <strong>phone number</strong>.</li>");
	}
	if (length($pf{address})<1) {
		push (@err,"<li>Please enter your <strong>street address</strong>.</li>");
	}
	if (length($pf{city})<1) {
		push (@err,"<li>Please enter your <strong>city</strong>.</li>");
	}
	if (length($pf{state})<1) {
		push (@err,"<li>Please enter your <strong>state</strong>.</li>");
	}
	if (length($pf{zip})<1) {
		push (@err,"<li>Please enter your <strong>zip code</strong>.</li>");
	}
if (@err<1) {
	if (index($pf{email},"\@")<1) {
		push (@err,"<li>Please enter your <strong>valid email address (1)</strong>.</li>");
	} elsif (index($pf{email},"\@")>rindex($pf{email},'.')) {
                push (@err,"<li>Please enter your <strong>valid email address (2).</strong></li>");
	} elsif (index($pf{email},'.')<1) {
		push (@err,"<li>Please enter your <strong>valid email address (3).</strong></li>");
	} elsif (rindex($pf{email},'.') == length($pf{email})-2) {
		push (@err,"<li>Please enter your <strong>valid email address (4).</strong></li>");
	}
}
	my $content = "";
	if (@err>0) {
		my $errstr = join("\n",@err);


        my $fn = STATIC_PATH.'join-errors.html';
        open (FILE,$fn) or die "Can't open $fn $!\n";
        my $form = do { local $/; <FILE> };
	foreach my $fld (keys %pf) {
		 $form =~ s/\<!--$fld--\>/$pf{$fld}/g;
	}
		


		$content = <<ERR
<h1>OOpS!</h1>
<p>There were some problems with the information you submitted. Please review the issues below and try again.</p>
<div style="padding:10px;background-color:#ff3300;">
<ul>
$errstr
</ul>
</div>
$form
ERR
	
	} else {

		my $db = eval { new DB(); } or die ("no db");
                my $conn = $db->connect();
		my $accounts = $conn->accounts;
		$accounts->insert(\%pf);
		$conn->close();


		$content = "<h1>OK</h1><p>Congratulations</p>";
		
	}
	return ($content);
}

sub postfields {
	my ( $self ) = @_;
	my %pf = ();
	my $tmpStr = '';
	my $part = '';
	read( STDIN, $tmpStr, $ENV{ "CONTENT_LENGTH" } );
	my @parts = split( /\&/, $tmpStr );
	foreach $part (@parts) {
		my ( $name, $value ) = split( /\=/, $part );
                $value =~ ( s/%23/\#/g );
                $value =~ ( s/%2F/\//g );
		$value =~ ( s/%40/\@/g );
		$value =~ ( s/\+/ /g );
		$pf{ "$name" } = $value;
	}
	$self->{_post} = %pf;
	return (%pf);
}


1;
