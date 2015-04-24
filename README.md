[![Build Status](https://travis-ci.org/pierre-vigier/Dancer2-Session-CGISession.svg?branch=master)](https://travis-ci.org/pierre-vigier/Dancer2-Session-CGISession)
[![Coverage Status](https://coveralls.io/repos/pierre-vigier/Dancer2-Session-CGISession/badge.png?branch=master)](https://coveralls.io/r/pierre-vigier/Dancer2-Session-CGISession?branch=master)

# NAME

Dancer2::Session::CGISession - Share Dancer Session with CGI::Session

# SYNOPSIS

    use Dancer2::Session::CGISession;

# DESCRIPTION

Dancer2::Session::CGISession is a session engine for Dancer2 to interact with CGI::Session;
Mostly usefull if you need to share sessions created by non-Dancer apps which are already using CGI::Session.
That Plugin is heavily inspired from Dancer::Session::CGISession

This module is a work in progress

You can set CGI::Session drivers and parameters using Dancer2 configuration

    session: "CGISession"

    engines:
      session:
        CGISession:
          driver: "driver:file:
          driver_params:
            "Directory": "/tmp
          name: "session name"

# AUTHOR

Pierre VIGIER <pierre.vigier@gmail.com>

# COPYRIGHT

Copyright 2015- Pierre VIGIER

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
