# This is a -*-perl-*- script
#
# Set variables that were defined by configure, in case we need them
# during the tests.

%CONFIG_FLAGS = (
    AM_LDFLAGS   => '-Wl,--export-dynamic',
    AR           => 'ar',
    CC           => '/bin/gcc',
    CFLAGS       => '-march=haswell -O2 -fstack-protector-strong -Wp,-D_FORTIFY_SOURCE=2',
    CPP          => 'cpp',
    CPPFLAGS     => '',
    GUILE_CFLAGS => '',
    GUILE_LIBS   => '',
    LDFLAGS      => '-Wl,-O1,--as-needed,-z,relro,-z,now -s',
    LIBS         => '-ldl '
);

1;
