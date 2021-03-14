cmake_minimum_required (VERSION 3.8)

file(GLOB SHADERS "${DIR}/*.vert" "${DIR}/*.frag")

foreach(SHADER ${SHADERS})
	message("Build ${SHADER}")
	execute_process(COMMAND ${GLSLC}  ${SHADER} "-o" "${SHADER}.spv")
	file(COPY "${SHADER}.spv" DESTINATION "${CMAKE_BINARY_DIR}/shaders")
	file(REMOVE "${SHADER}.spv")
endforeach()
