cmake_minimum_required(VERSION 3.28)
project(CppProjectBase VERSION 0.0.1 LANGUAGES CXX)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/generators")
find_package(SFML REQUIRED COMPONENTS system window graphics)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_SOURCE_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_SOURCE_DIR}/bin)

set(MY_TARGET cpp_project_base)
add_executable(${MY_TARGET} src/main.cpp)

target_compile_features(${MY_TARGET} PRIVATE cxx_std_17)
target_link_libraries(${MY_TARGET} PUBLIC sfml::sfml)

# --- RPATH setup ---
set_target_properties(${MY_TARGET} PROPERTIES
    BUILD_WITH_INSTALL_RPATH TRUE
    INSTALL_RPATH "$ORIGIN"
    INSTALL_RPATH_USE_LINK_PATH TRUE
)