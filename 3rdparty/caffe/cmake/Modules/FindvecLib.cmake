# Find the vecLib libraries as part of Accelerate.framework or as standalon framework
#
# The following are set after configuration is done:
#  VECLIB_FOUND
#  vecLib_INCLUDE_DIR
#  vecLib_LINKER_LIBS


if(NOT APPLE)
  return()
endif()

set(__veclib_include_suffix "Frameworks/vecLib.framework/Versions/Current/Headers")

exec_program(xcode-select ARGS -print-path OUTPUT_VARIABLE CMAKE_XCODE_DEVELOPER_DIR)
find_path(vecLib_INCLUDE_DIR vecLib.h
          DOC "vecLib include directory"
          PATHS /System/Library/Frameworks/Accelerate.framework/Versions/Current/${__veclib_include_suffix}
                /System/Library/${__veclib_include_suffix}
                ${CMAKE_XCODE_DEVELOPER_DIR}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Accelerate.framework/Versions/Current/Frameworks/vecLib.framework/Headers/
          NO_DEFAULT_PATH)

set(vecLib_INCLUDE_DIR "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/Accelerate.framework/Versions/Current/Frameworks/vecLib.framework/Headers/")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(vecLib DEFAULT_MSG vecLib_INCLUDE_DIR)

if(VECLIB_FOUND)
  if(vecLib_INCLUDE_DIR MATCHES "^/System/Library/Frameworks/vecLib.framework.*")
    set(vecLib_LINKER_LIBS -lcblas "-framework vecLib")
    message(STATUS "Found standalone vecLib.framework")
  else()
    set(vecLib_LINKER_LIBS -lcblas "-framework Accelerate")
    message(STATUS "Found vecLib as part of Accelerate.framework")
  endif()

  mark_as_advanced(vecLib_INCLUDE_DIR)
endif()
