cmake_minimum_required(VERSION 3.28)
project(TestConanProject LANGUAGES CXX)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/generators")
find_package(SFML REQUIRED COMPONENTS system window graphics)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/bin)

set(MY_TARGET testConan)
add_executable(${MY_TARGET} src/main.cpp)

target_compile_features(${MY_TARGET} PRIVATE cxx_std_17)
# target_include_directories(${MY_TARGET} PUBLIC ${SFML_INCLUDE_DIRS})
target_link_libraries(${MY_TARGET} PUBLIC ${SFML_LIBRARIES})