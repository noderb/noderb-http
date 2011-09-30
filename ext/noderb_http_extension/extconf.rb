require "mkmf"

$CFLAGS = CONFIG['CFLAGS'] = " -fPIC -shared "

create_makefile("noderb_http_extension")