

function(buildx_copy_dependency _target)

	if(NOT TARGET ${_target})
		message(FATAL_ERROR "'${_target}' is not a target yet! Forgott to import?")
	endif()

	get_property(type TARGET ${_target} PROPERTY TYPE)
	if(NOT ${type} STREQUAL "STATIC_LIBRARY")
		buildx_debug("Copy dynamic libraries for target '${_target}'" dep)
		add_custom_command(	TARGET ctest POST_BUILD
							COMMAND ${CMAKE_COMMAND} -E
							copy_if_different $<TARGET_PROPERTY:abc::abclib,IMPORTED_LOCATION_$<UPPER_CASE:$<CONFIG>>> $<TARGET_FILE_DIR:ctest>)
	endif()

	# recursive
	get_property(linkl TARGET ${_target} PROPERTY INTERFACE_LINK_LIBRARIES)
	foreach(li ${linkl})
		buildx_copy_dependency(${li})		
	endforeach()
endfunction()

function(buildx_copy_target_dependencies _target)

	get_property(linkl TARGET ${_target} PROPERTY LINK_LIBRARIES)
	foreach(li ${linkl})
		
		buildx_copy_dependency(${li})
	endforeach()
endfunction()