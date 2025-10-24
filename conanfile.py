import os
from conan import ConanFile
from conan.tools.cmake import cmake_layout
from conan.tools.files import copy

class ConanProjectConan(ConanFile):
    name = "conan_project"
    version = "1.0"

    settings = "os", "compiler", "build_type", "arch"
    requires = "sfml/2.6.2"
    generators = "CMakeDeps", "CMakeToolchain"

    # NOTE: Static linking is recommended to make the executable fully portable
    # and avoid missing system libraries (needed by your libs)
    default_options = {
        "sfml/*:shared": False,
        "sfml/*:graphics": True,
        "sfml/*:window": True,
        "sfml/*:audio": True,
        "sfml/*:network": True,
        "sfml/*:system": True,
    }
    
    def configure(self):
        if self.settings.compiler == "msvc":
                    self.settings.compiler.runtime = "static"
        
    def layout(self):
        # Basic layout but force the generator folder path
        self.folders.build = "build"
        self.folders.generators = "build/generators"
        #cmake_layout(self)

    def generate(self):
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