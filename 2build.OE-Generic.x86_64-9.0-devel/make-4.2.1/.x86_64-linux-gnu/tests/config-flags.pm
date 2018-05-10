# This is a -*-perl-*- script
#
# Set variables that were defined by configure, in case we need them
# during the tests.

%CONFIG_FLAGS = (
    AM_LDFLAGS   => '-Wl,--export-dynamic',
    AR           => 'ar',
    CC           => '/usr/bin/gcc',
    CFLAGS       => '-march=westmere -mtune=haswell -O2 -pipe -I/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/include -Wno-format-security',
    CPP          => 'cpp',
    CPPFLAGS     => '',
    GUILE_CFLAGS => '',
    GUILE_LIBS   => '',
    LDFLAGS      => '-Wl,-rpath,/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/lib -L/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/toolchain/lib -s',
    LIBS         => '-ldl '
);

1;
