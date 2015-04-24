use strict;
use warnings;

package TestServer;
use Dancer2;

setting(session => "CGISession");

get '/no_session_data' => sub {
    return "session not modified";
};

get '/set_session/*' => sub {
    my ($name) = splat;
    session name => $name;
};

get '/read_session' => sub {
    my $name = session 'name';
    return "name='$name'";
};

get '/destroy_session' => sub {
    my $name = session('name') || '';
    app->destroy_session;
    return "destroyed='$name'";
};

get '/churn_session' => sub {
    app->destroy_session;
    session name => 'damian';
    return "churned";
};

1;

package main;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;
use HTTP::Cookies;
use Data::Dumper;

my $test = Plack::Test->create( TestServer->to_app );
my $jar = HTTP::Cookies->new( autosave => 1, );

my $req = GET 'http://localhost/no_session_data';
$jar->add_cookie_header($req);
my $res = $test->request( $req );
ok( $res->is_success, 'Successful request' );
$jar->extract_cookies($res);
ok( !$jar->as_string, 'No cookie as nothing stored in session');

$req = GET 'http://localhost/set_session/John';
$jar->add_cookie_header($req);
$res = $test->request( $req );
ok( $res->is_success, 'Successful request' );
$jar->extract_cookies($res);
ok( $jar->as_string, 'Session created, cookie set' );
my $jar_content = $jar->as_string;

$req = GET 'http://localhost/read_session';
$jar->add_cookie_header($req);
$res = $test->request( $req );
ok( $res->is_success, 'Successful request' );
is( $res->content, "name='John'", 'Correct value retrieved from session');
$jar->extract_cookies($res);
ok( $jar->as_string, 'Cookie is still there' );
is( $jar->as_string, $jar_content, "Session cookie did not change");
$jar_content = $jar->as_string;

$req = GET 'http://localhost/churn_session';
$jar->add_cookie_header($req);
$res = $test->request( $req );
ok( $res->is_success, 'Successful request' );
is( $res->content, "churned", 'Correct value' ); 
$jar->extract_cookies($res);
ok( $jar->as_string, 'Cookie is there' );
isnt( $jar->as_string, $jar_content, "Session cookie did change");
$jar_content = $jar->as_string;

$req = GET 'http://localhost/read_session';
$jar->add_cookie_header($req);
$res = $test->request( $req );
ok( $res->is_success, 'Successful request' );
is( $res->content, "name='damian'", 'Correct value retrieved from session after churn');
$jar->extract_cookies($res);
ok( $jar->as_string, 'Cookie is still there' );
is( $jar->as_string, $jar_content, "Session cookie did not change");
$jar_content = $jar->as_string;

$req = GET 'http://localhost/destroy_session';
$jar->add_cookie_header($req);
$res = $test->request( $req );
ok( $res->is_success, 'Successful request' );
is( $res->content, "destroyed='damian'", 'Correct value retrieved from session');
$jar->extract_cookies($res);
ok( !$jar->as_string, 'Cookie has been trashed' );

done_testing;
