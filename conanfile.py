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

    default_options = {
        "sfml/*:shared": True,
        "sfml/*:graphics": True,
        "sfml/*:window": True,
        "sfml/*:audio": True,
        "sfml/*:network": True,
        "sfml/*:system": True,
    }

    def layout(self):
        cmake_layout(self)

    def generate(self):
        # Detect build type (Release/Debug)
        # build_type = str(self.settings.build_type)
        exe_dir = os.path.join(self.build_folder, "bin")
        os.makedirs(exe_dir, exist_ok=True)
        for dep in self.dependencies.values():
            # DYLIB (MacOS)
            for lib_path in dep.cpp_info.libdirs:
                copy(self, "*.dylib", src=lib_path, dst=exe_dir)
            # DLL (Windows)
            for bin_path in dep.cpp_info.bindirs:
                copy(self, "*.dll", src=bin_path, dst=exe_dir) 