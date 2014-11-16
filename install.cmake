#
#	buildx_install_package(	TARGET <target>
#							
#							[PACKAGE_NAME <package-name>]
#							
#							[PACKAGE_CONFIG_FILE <config-file>]
#							[PACKAGE_VERSION_FILE <version-file>]
#
#							[BUILD_EXPORT_DIR <dir>]
#
#							[NAMESPACE <namespace>])





#	buildx_target_includes(	TARGETS <target>
#							BASE_DIRECTORIES <dir>
#							DESTINATION <dir>
#							[FILES <headers>]
#							[CONFIGURATIONS <configurations>]
#							[COMPONENT <component>])
#
function(buildx_target_includes)

	set(options)
	set(oneValueArgs DESTINATION COMPONENT)
	set(multiValueArgs TARGETS CONFIGURATIONS FILES BASE_DIRECTORIES)
	cmake_parse_arguments(_arg "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

	if(NOT _arg_TARGETS)
		buildx_debug("No Targets specified!" install)
		return()
	endif(NOT _arg_TARGETS)
	
	if(NOT _arg_BASE_DIRECTORIES)
		buildx_debug("No base directories specified!" install)
		return()
	endif(NOT _arg_BASE_DIRECTORIES)
	
	if(NOT DEFINED _arg_DESTINATION)
		message(FATAL_ERROR "No include destination specified!")
	endif(NOT DEFINED _arg_DESTINATION)

	foreach(bdir ${_arg_BASE_DIRECTORIES})
		set(base_dirs ${base_dirs} ${bdir}/)
	endforeach()
	
	if(NOT DEFINED _arg_FILES)
		# install directory		
		install(DIRECTORY ${base_dirs}
				DESTINATION ${_arg_DESTINATION}
				CONFIGURATIONS ${_arg_CONFIGURATIONS}
				COMPONENT ${_arg_COMPONENT}
				PATTERN "scripts/*")
	else()
		foreach(header ${_arg_FILES})
			get_filename_component(hdir "${header}" DIRECTORY)
			foreach(bdir ${_arg_BASE_DIRECTORIES})
				string(FIND ${hdir} ${bdir} fres)
				if(${fres} EQUAL 0)
					#found
					string(LENGTH "${bdir}" dlength)
					string(SUBSTRING ${hdir} ${dlength} -1 incl_dir)
					buildx_debug("Install include directory: '${incl_dir}'" install)
					install(FILES ${header}
							DESTINATION ${_arg_DESTINATION}/${incl_dir}
							CONFIGURATIONS ${_arg_CONFIGURATIONS}
							COMPONENT ${_arg_COMPONENT})
					
					break()
				endif(${fres} EQUAL 0)
			endforeach()
			
		endforeach()
	endif()
	
	# add paths to targets
	foreach(trg ${_arg_TARGETS})
		buildx_debug("Include directories for Target ${trg}" install)
		foreach(bdir ${_arg_BASE_DIRECTORIES})
			buildx_debug("  Build:   '${bdir}'" install)
			target_include_directories(${trg} PUBLIC $<BUILD_INTERFACE:${bdir}>)
		endforeach()
		
		buildx_debug("  Install: '<prefix>/${_arg_DESTINATION}'" install)
		target_include_directories(${trg} PUBLIC $<INSTALL_INTERFACE:${_arg_DESTINATION}>)
	endforeach()
	
	#set_target_properties(<lib> PROPERTIES
	#  PUBLIC_HEADER "${PUBLIC_INCLUDES}")
	 

endfunction(buildx_target_includes)