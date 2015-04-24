requires 'perl', '5.008005';

requires 'CGI::Session', '4.48';

on test => sub {
    requires 'Test::More', '0.96';
    requires 'Plack::Test', '1.00';
    requires 'HTTP::Request::Common','6.04';
    requires 'HTTP::Cookies','6.01';
};
