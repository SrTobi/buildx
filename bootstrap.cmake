
include("debug.cmake")

# check needed buildx variables
if(NOT DEFINED PROJECT_NAME)
	message(FATAL_ERROR "Buildx: No project name specified!")
endif(NOT DEFINED PROJECT_NAME)

if(NOT PROJECT_VERSION)
	message(WARNING "Buildx: Please specify a version for the project!")
endif(NOT PROJECT_VERSION)

if(NOT DEFINED PROJECT_SHORTCUT)
	set(PROJECT_SHORTCUT ${PROJECT_NAME})
endif(NOT DEFINED PROJECT_SHORTCUT)

if(NOT DEFINED PROJECT_PREFIX)
	set(PROJECT_PREFIX ${PROJECT_SHORTCUT})
endif(NOT DEFINED PROJECT_PREFIX)

include("print_properties.cmake")
include("pch.cmake")
# include("copy_media.cmake")
include("src_scanner.cmake")
include("library.cmake")
include("install.cmake")
include("dependencies.cmake")
include("utils.cmake")
include("test.cmake")