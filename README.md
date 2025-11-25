# 🌠 CppProjectBase

[![CMake](https://img.shields.io/badge/CMake-064F8C?logo=cmake&logoColor=fff)](https://cmake.org/)
[![Conan](https://img.shields.io/badge/-Conan-6699CB?style=flat&logo=conan&logoColor=white)](https://conan.io/)
[![Platforms](https://img.shields.io/badge/Platforms-Windows%20%F0%9F%AA%9F%20%7C%20%F0%9F%90%A7%20Linux-F7C59F?labelColor=0D1117)](#-build--run-instructions)
[![Programming languages](https://img.shields.io/badge/C++-027FDE?style=flat-square&logo=C%2B%2B&logoColor=white)](https://isocpp.org/)

**CppProjectBase** is a minimal **C++ template** designed to quickly bootstrap **cross-platform (Windows / Linux)** projects using **CMake** and **Conan**.  
It currently integrates SFML packages added via Conan, includes a simple `main.cpp`, a basic `CMakeLists.txt`, and build scripts for Windows and Linux.  
<br>

## ⚙️ Features & Goals
This repository serves as a **clean, modern foundation** for new C++ projects:
- Portable setup using **CMake**  
- Dependency management with **Conan**  
- Ready-to-use build scripts for **Windows** and **Linux**  
- Ideal for any C++ application
- Continuous Integration with **GitHub Actions**
<br>

## 📁 Project Structure
| Path | Description |
|------|--------------|
| `CMakeLists.txt` | Main CMake configuration file |
| `conanfile.py` | Conan dependency definitions (includes SFML) |
| `.gitignore` | Excludes build and temporary files |
| `src/` | Project source files |
| `include/` | Public header files - In case you're building a library or a package |
| `lib/` | Third party librairies |
| `docs/` | Documentation files |
| `.github/` | Configuration files for GitHub Actions and other GitHub features |
| `scripts/` | Helper scripts for setup, builds or other tasks |

<br>

## 🧰 Prerequisites

#### 🪟 Windows
- [Python 3](https://www.python.org/downloads/) — required for Conan
- [CMake](https://cmake.org/download/) ≥ 3.27
- [Visual Studio](https://visualstudio.microsoft.com/) — with C++ desktop development tools   
 

#### 🐧 Linux
- **GCC** (added with build essentials)
- **CMake** ≥ 3.27
- **Python 3**  
- **Make**
<br>

## 💻 Build an run Instructions
#### 1. Clone the repository
```bash
git clone https://github.com/Cesca19/CppProjectBase.git
cd CppProjectBase
```
<br>

#### 2. Launch the build scripts
Open your terminal at the root of the repository and launch the following commands

##### On Linux
```
  ./scripts/build_linux.sh
```

##### On Windows
```
  .\scripts\build_windows.bat
```
<br>

#### 3. Execute the binaries
Ater a successful build, execute the binaries by launching the following commands

##### On Linux
```
  ./bin/cpp_project_base
```

##### On Windows
```
  .\bin\cpp_project_base.exe
```
<br>

## 🛠️ Build Options
The build scripts support configurable options:
* Build Type: Debug (default) or Release
* Runtime Link: dynamic (default) or static
Example:
```
./scripts/build_linux.sh Release static
```
This will produce a Release build with static libgcc/libstdc++, leaving system libraries dynamic. Only the direct dependencies listed in conanfile.py will follow this shared/static setting. 

<br>

## ➿ Continuous Integration (GitHub Actions)
This project includes a ready-to-use CI/CD pipeline powered by GitHub Actions. This pipeline contain
two functionalities : a **build and test of your project on windows and linux** and the creation of a **release 
of your project for windows and linux platforms**
<br><br>

#### 📦 Automated Build & Test on Windows and Linux
Every time you push to the main branch with a commit message containing [build],
GitHub Actions will:
* Automatically run builds on Windows and Linux.
* Cache Conan dependencies (SFML, etc.) to speed up builds.
* Run basic tests and compress the binaries.
* Upload the build artifacts for download.

##### ▶️ How to Trigger manually
```
   git add .
   git commit -m "Update something [build]"
   git push origin main
```

##### 🧭 Where to Find Build Artifacts 
Go to your repository’s Actions tab.
* Open the latest workflow run (titled “Build, Test and Release”).
* Scroll to the bottom of the page — you’ll find a section named **“Artifacts”.**
* Download the artifact corresponding to your system:
  * Windows-build → contains the .exe and required files
  * Linux-build → contains the ELF binary and dependencies
<br>

#### 🚀 Create a Release for Windows and Linux 
When you push a tag starting with v (for example v1.0.0), GitHub Actions will automatically:
* Build and test on the project both platforms.
* Download the generated artifacts.
* Create a new GitHub Release with .zip files for Windows and Linux attached.

##### ▶️ How to Trigger manually
```
git tag v1.0.0
git push origin v1.0.0
```

##### 🧭 Where to find the realease
Once complete, your release will appear in the release section of your repository home page

<br>

## 🗒️ Notes
* You can customize dependencies directly in `conanfile.py`.
* The build scripts automatically create and configure the `build/` directory.
* Ideal starting point for SFML, SDL, ImGui, boost or pure C++ projects.




