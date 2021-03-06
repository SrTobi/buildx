


macro(buildx_enable_pch)

	option(Option_USE_PRE_COMPILED_HEADER		"Use precompiled header for compilation" ON)

	if(Option_USE_PRE_COMPILED_HEADER)
		
		add_definitions("-D${PROJECT_PREFIX}_USE_PRECOMPILED_HEADER")
		
		macro(buildx_pch _targetName _input)
			buildx_pch_impl(${_targetName} ${_input})
		endmacro()
		
		
	else(Option_USE_PRE_COMPILED_HEADER)

		# set an empty macro
		macro(buildx_pch _targetName _input)
		endmacro()

	endif(Option_USE_PRE_COMPILED_HEADER)


endmacro()





function(buildx_pch_impl _targetName _input)
	GET_FILENAME_COMPONENT(_inputWe ${_input} NAME_WE)
	SET(pch_source ${_inputWe}.cpp)
	FOREACH(arg ${ARGN})
		IF(arg STREQUAL FORCEINCLUDE)
			SET(FORCEINCLUDE ON)
		ELSE(arg STREQUAL FORCEINCLUDE)
			SET(FORCEINCLUDE OFF)
		ENDIF(arg STREQUAL FORCEINCLUDE)
	ENDFOREACH(arg)

	IF(MSVC)
		GET_TARGET_PROPERTY(sources ${_targetName} SOURCES)
		SET(_sourceFound FALSE)
		FOREACH(_source ${sources})
			SET(PCH_COMPILE_FLAGS "")
			IF(_source MATCHES \\.\(cc|cxx|cpp\)$)
				GET_FILENAME_COMPONENT(_sourceWe ${_source} NAME_WE)
				GET_FILENAME_COMPONENT(_pch_file ${_input} NAME)
				IF(_sourceWe STREQUAL ${_inputWe})
				SET(PCH_COMPILE_FLAGS "${PCH_COMPILE_FLAGS} /Yc${_pch_file}")
				SET(_sourceFound TRUE)
				ELSE(_sourceWe STREQUAL ${_inputWe})
				SET(PCH_COMPILE_FLAGS "${PCH_COMPILE_FLAGS} /Yu${_pch_file}")
				IF(FORCEINCLUDE)
				SET(PCH_COMPILE_FLAGS "${PCH_COMPILE_FLAGS} /FI${_pch_file}")
				ENDIF(FORCEINCLUDE)
				ENDIF(_sourceWe STREQUAL ${_inputWe})
				SET_SOURCE_FILES_PROPERTIES(${_source} PROPERTIES COMPILE_FLAGS "${PCH_COMPILE_FLAGS}")
			ENDIF(_source MATCHES \\.\(cc|cxx|cpp\)$)
		ENDFOREACH()
		IF(NOT _sourceFound)
			MESSAGE(FATAL_ERROR "A source file for ${_input} was not found. Required for MSVC builds.")
		ENDIF(NOT _sourceFound)
	ENDIF(MSVC)

	IF(CMAKE_COMPILER_IS_GNUCXX)
		GET_FILENAME_COMPONENT(_name ${_input} NAME)
		SET(_source "${_input}")
		SET(_outdir "${CMAKE_CURRENT_BINARY_DIR}/${_name}.gch")
		MAKE_DIRECTORY(${_outdir})
		SET(_output "${_outdir}/.c++")

		STRING(TOUPPER "CMAKE_CXX_FLAGS_${CMAKE_BUILD_TYPE}" _flags_var_name)

		SET(_compiler_FLAGS ${${_flags_var_name}})

		GET_DIRECTORY_PROPERTY(_directory_flags DEFINITIONS)
		LIST(APPEND _compiler_FLAGS "${_directory_flags}")
		
		SEPARATE_ARGUMENTS(_compiler_FLAGS)

		GET_DIRECTORY_PROPERTY(_directory_flags INCLUDE_DIRECTORIES)
		FOREACH(item ${_directory_flags})
			LIST(APPEND _compiler_FLAGS "-I${item}")
			#MESSAGE("${item}")
		ENDFOREACH(item)

		# MESSAGE("${CMAKE_CXX_COMPILER} -DPCHCOMPILE ${_compiler_FLAGS}. -x c++-header -o ${_output} ${_source}")
		ADD_CUSTOM_COMMAND(
			OUTPUT ${_output}
			COMMAND ${CMAKE_CXX_COMPILER} ${_compiler_FLAGS} -x c++-header -o ${_output} ${_source}
			DEPENDS ${_source} )
		ADD_CUSTOM_TARGET(${_targetName}_gch DEPENDS ${_output})
		ADD_DEPENDENCIES(${_targetName} ${_targetName}_gch)
		SET_TARGET_PROPERTIES(${_targetName} PROPERTIES COMPILE_FLAGS "-include ${_name} -Winvalid-pch")
	ENDIF(CMAKE_COMPILER_IS_GNUCXX)
endfunction()

