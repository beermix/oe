# CMake generated Testfile for 
# Source directory: /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Tests/CMakeLib
# Build directory: /home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Tests/CMakeLib
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(CMakeLib.testGeneratedFileStream "CMakeLibTests" "testGeneratedFileStream")
add_test(CMakeLib.testRST "CMakeLibTests" "testRST" "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Tests/CMakeLib")
add_test(CMakeLib.testSystemTools "CMakeLibTests" "testSystemTools")
add_test(CMakeLib.testUTF8 "CMakeLibTests" "testUTF8")
add_test(CMakeLib.testXMLParser "CMakeLibTests" "testXMLParser")
add_test(CMakeLib.testXMLSafe "CMakeLibTests" "testXMLSafe")
add_test(CMakeLib.testFindPackageCommand "CMakeLibTests" "testFindPackageCommand")
add_test(CMakeLib.testUVRAII "CMakeLibTests" "testUVRAII")
subdirs("PseudoMemcheck")
