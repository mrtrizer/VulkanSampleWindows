cmake_minimum_required (VERSION 3.8)

set(PROJECT_NAME SimpleVulkan)

add_executable (${PROJECT_NAME} "main.c")

find_package(Vulkan REQUIRED)

target_include_directories(${PROJECT_NAME} PRIVATE "./")

target_link_libraries(${PROJECT_NAME} Vulkan::Vulkan)

target_compile_definitions(${PROJECT_NAME} PRIVATE VK_USE_PLATFORM_WIN32_KHR)

set(GLSLC "${Vulkan_INCLUDE_DIR}/../Bin/glslc.exe")

message("CMAKE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}")

set(SHADERS_IN_DIR "${CMAKE_CURRENT_SOURCE_DIR}/shaders")
set(SHADERS_OUT_DIR "${CMAKE_BINARY_DIR}/${PROJECT_NAME}/shaders")

file(GLOB SHADERS "${SHADERS_IN_DIR}/*.vert" "${SHADERS_IN_DIR}/*.frag")

file(MAKE_DIRECTORY ${SHADERS_OUT_DIR})

foreach(SHADER ${SHADERS})
	get_filename_component(SHADER_NAME ${SHADER} NAME)
	set(SHADER_OUT_NAME "${SHADERS_OUT_DIR}/${SHADER_NAME}.spv")
	list(APPEND SHADER_OUT_NAMES ${SHADER_OUT_NAME})
	add_custom_command(
		MAIN_DEPENDENCY ${SHADER}
		OUTPUT ${SHADER_OUT_NAME}
		COMMAND ${GLSLC}  ${SHADER} "-o" ${SHADER_OUT_NAME}
		VERBATIM)
endforeach()

add_custom_target(build_shaders DEPENDS ${SHADER_OUT_NAMES})

add_dependencies(${PROJECT_NAME} build_shaders)