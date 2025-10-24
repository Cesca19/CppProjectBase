cmake_minimum_required(VERSION 3.20)
project(CppProjectBase VERSION 0.0.1 LANGUAGES CXX)

# --- Force static linking of C++ runtimes ---
if (MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
else()
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static-libstdc++ -static-libgcc")
endif()

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/generators")
find_package(SFML REQUIRED COMPONENTS system window graphics)

set(TARGET_BINARY_DIR ${CMAKE_SOURCE_DIR}/bin)
set(TARGET_LIBRAIRIES_DIR ${CMAKE_SOURCE_DIR}/bin/lib)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${TARGET_BINARY_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${TARGET_BINARY_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${TARGET_BINARY_DIR})

set(CMAKE_SKIP_BUILD_RPATH FALSE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
set(CMAKE_INSTALL_RPATH "$TARGET_LIBRAIRIES_DIR")
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH FALSE)
set(CMAKE_BUILD_RPATH "$TARGET_LIBRAIRIES_DIR")

set(MY_TARGET cpp_project_base)
add_executable(${MY_TARGET} src/main.cpp)

target_compile_features(${MY_TARGET} PRIVATE cxx_std_17)
target_link_libraries(${MY_TARGET} PUBLIC sfml::sfml)

set_target_properties(${MY_TARGET} PROPERTIES INSTALL_RPATH "$TARGET_LIBRAIRIES_DIR")


 # --- Linux static lib   ---
if(UNIX AND NOT APPLE)
    add_custom_command(TARGET ${MY_TARGET} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory $<TARGET_FILE_DIR:${MY_TARGET}>/lib
        COMMAND bash ${CMAKE_SOURCE_DIR}/scripts/copy_linux_libs.sh $<TARGET_FILE:${MY_TARGET}> ${TARGET_LIBRAIRIES_DIR}
       ## COMMAND patchelf --set-rpath '$ORIGIN' $<TARGET_FILE:${MY_TARGET}>
    )
endif()