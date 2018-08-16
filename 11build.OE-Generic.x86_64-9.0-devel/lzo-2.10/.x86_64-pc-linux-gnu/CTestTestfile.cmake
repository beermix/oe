# CMake generated Testfile for 
# Source directory: /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10
# Build directory: /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/.x86_64-pc-linux-gnu
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(simple "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/.x86_64-pc-linux-gnu/simple")
add_test(testmini "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/.x86_64-pc-linux-gnu/testmini")
add_test(lzotest-01 "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/.x86_64-pc-linux-gnu/lzotest" "-mlzo" "-n2" "-q" "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/COPYING")
add_test(lzotest-02 "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/.x86_64-pc-linux-gnu/lzotest" "-mavail" "-n10" "-q" "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/COPYING")
add_test(lzotest-03 "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/.x86_64-pc-linux-gnu/lzotest" "-mall" "-n10" "-q" "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/lzo-2.10/include/lzo/lzodefs.h")
