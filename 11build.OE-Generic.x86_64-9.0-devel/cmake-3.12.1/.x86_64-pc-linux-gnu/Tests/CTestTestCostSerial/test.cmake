cmake_minimum_required(VERSION 2.4)

# Settings:
set(CTEST_DASHBOARD_ROOT                "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Tests/CTestTest")
set(CTEST_SITE                          "vmware")
set(CTEST_BUILD_NAME                    "CTestTest-Linux-host-g++-CostSerial")

set(CTEST_SOURCE_DIRECTORY              "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/Tests/CTestTestCostSerial")
set(CTEST_BINARY_DIRECTORY              "/home/user/-f2fs/oe/build.OE-Generic.x86_64-9.0-devel/cmake-3.12.1/.x86_64-pc-linux-gnu/Tests/CTestTestCostSerial")
set(CTEST_CVS_COMMAND                   "CVSCOMMAND-NOTFOUND")
set(CTEST_CMAKE_GENERATOR               "Unix Makefiles")
set(CTEST_CMAKE_GENERATOR_PLATFORM      "")
set(CTEST_CMAKE_GENERATOR_TOOLSET       "")
set(CTEST_BUILD_CONFIGURATION           "$ENV{CMAKE_CONFIG_TYPE}")
set(CTEST_COVERAGE_COMMAND              "/bin/gcov")
set(CTEST_NOTES_FILES                   "${CTEST_SCRIPT_DIRECTORY}/${CTEST_SCRIPT_NAME}")

#CTEST_EMPTY_BINARY_DIRECTORY(${CTEST_BINARY_DIRECTORY})

# Remove old cost data file if it exists
if(EXISTS "${CTEST_BINARY_DIRECTORY}/Testing/Temporary/CTestCostData.txt")
  file(REMOVE "${CTEST_BINARY_DIRECTORY}/Testing/Temporary/CTestCostData.txt")
endif()

CTEST_START(Experimental)
CTEST_CONFIGURE(BUILD "${CTEST_BINARY_DIRECTORY}" RETURN_VALUE res)
CTEST_BUILD(BUILD "${CTEST_BINARY_DIRECTORY}" RETURN_VALUE res)
CTEST_TEST(BUILD "${CTEST_BINARY_DIRECTORY}" RETURN_VALUE res)
# Run test set a second time to make sure they run in same specified order
CTEST_TEST(BUILD "${CTEST_BINARY_DIRECTORY}" RETURN_VALUE res)
