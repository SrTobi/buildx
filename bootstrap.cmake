


# check needed buildx variables
if(NOT DEFINED PROJECT_NAME)
	message(FATAL_ERROR "No project name specified!")
endif(NOT DEFINED PROJECT_NAME)

if(NOT DEFINED PROJECT_SHORTCUT)
	set(PROJECT_SHORTCUT ${PROJECT_NAME})
endif(NOT DEFINED PROJECT_SHORTCUT)

if(NOT DEFINED PROJECT_PREFIX)
	set(PROJECT_PREFIX ${PROJECT_SHORTCUT})
endif(NOT DEFINED PROJECT_PREFIX)


include("debug.cmake")
include("pch.cmake")
include("copy_media.cmake")
include("src_scanner.cmake")