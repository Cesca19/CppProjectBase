cmake_minimum_required(VERSION 3.28)
project(TestConanProject LANGUAGES CXX)

find_package(SFML REQUIRED COMPONENTS system window graphics)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

add_executable(testConan src/main.cpp)
#target_compile_features(testConan PRIVATE cxx_std_17)
target_link_libraries(testConan PRIVATE SFML::graphics)