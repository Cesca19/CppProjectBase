import os
from conan import ConanFile
from conan.tools.cmake import cmake_layout
from conan.tools.files import copy
from conan.tools.cmake import CMakeToolchain, CMakeDeps

class ConanProjectConan(ConanFile):
    name = "conan_project"
    version = "1.0"

    settings = "os", "compiler", "build_type", "arch"
    requires = "sfml/2.6.2"
    generators = "CMakeDeps"
    
    # Added option to control runtime linking style
    default_options = {
        "sfml/*:graphics": True,
        "sfml/*:window": True,
        "sfml/*:audio": True,
        "sfml/*:network": True,
        "sfml/*:system": True,
    }     
        
    def layout(self):
        """Defines folder structure for build and generated files"""
        self.folders.build = "build"
        self.folders.generators = "build/generators"

    def generate(self):
        """Passes runtime link type to CMake through toolchain variables."""
        tc = CMakeToolchain(self)
        tc.variables["RUNTIME_LINK"] = str(self.settings.compiler.runtime)
        tc.generate()
        """Copies dependency DLLs (like SFML) next to the final executable."""
        # Detect build type (Release/Debug)
        # build_type = str(self.settings.build_type)
        exe_dir = os.path.join(self.source_folder, "bin")
        os.makedirs(exe_dir, exist_ok=True)
        for dep in self.dependencies.values():
            # SO (Linux)
            for lib_path in dep.cpp_info.libdirs:
                copy(self, "*.so*", src=lib_path, dst=exe_dir)
            # DYLIB (MacOS)
            for lib_path in dep.cpp_info.libdirs:
                copy(self, "*.dylib", src=lib_path, dst=exe_dir)
            # DLL (Windows)
            for bin_path in dep.cpp_info.bindirs:
                copy(self, "*.dll", src=bin_path, dst=exe_dir)








        
