
set(_BUILDX_TESTX_INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/testx/include" PARENT_SCOPE)
set(_BUILDX_TESTX_MODULE_CONFIG_FILE "${CMAKE_CURRENT_LIST_DIR}/configs/test-module-config.cpp" PARENT_SCOPE)

# buildx_add_test(	target_name
#					test_path)
macro(buildx_add_test _name _test_path)

	find_package(Boost REQUIRED)

	# configure module file
	set(TESTX_MODULE_NAME ${_name})
	set(config_file_target ${CMAKE_CURRENT_BINARY_DIR}/${_name}-module.cpp)
	configure_file(${_BUILDX_TESTX_MODULE_CONFIG_FILE} ${config_file_target} @ONLY)
	
	
	buildx_scan(_BUILDX_TMP_TEST_SOURCE ${_test_path} "hpp;cpp")
	add_executable(${_name} ${ARGN} ${_BUILDX_TMP_TEST_SOURCE} ${config_file_target})
	set_target_properties(${_name} PROPERTIES COMPILE_DEFINITIONS "TESTX_TEST")
	target_include_directories(${_name} PRIVATE ${_BUILDX_TESTX_INCLUDE_DIR} ${Boost_INCLUDE_DIRS})
	target_link_libraries(${_name} ${Boost_LIBRARIES})

endmacro(buildx_add_test)