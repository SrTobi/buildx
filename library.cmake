
#	buildx_export_header(	<target>
#							[DESTINATION_FILE <out-file>]
#							[DESTINATION_DIR <out-path>]
#							[NAME <name>]
#
function(buildx_export_header _target)

	set(options)
	set(oneValueArgs DESTINATION_FILE DESTINATION_DIR NAME)
	set(multiValueArgs)
	cmake_parse_arguments(_arg "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
	
	# default options
	set(out_path ${CMAKE_CURRENT_BINARY_DIR}/generated_includes)
	
	set(name ${_target})
	if(_arg_NAME)
		set(name ${_arg_NAME})
	endif()
	set(out_file ${out_path}/${name}_api.hpp)
	
	
	
	generate_export_header(	${_target}
							EXPORT_FILE_NAME ${out_file}
							BASE_NAME ${name}
							)
							
	if(_arg_DESTINATION_FILE)
		set(${_arg_DESTINATION_FILE} ${${_arg_DESTINATION_FILE}} ${out_file} PARENT_SCOPE)
	endif()
	
	if(_arg_DESTINATION_DIR)
		set(${_arg_DESTINATION_DIR} ${${_arg_DESTINATION_DIR}} ${out_path} PARENT_SCOPE)
	endif()
endfunction()

