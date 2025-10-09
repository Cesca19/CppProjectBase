# 🌠 CppProjectBase

![CMake](https://img.shields.io/badge/CMake-064F8C?logo=cmake&logoColor=fff)
![Conan](https://img.shields.io/badge/-Conan-6699CB?style=flat&logo=conan&logoColor=white)
![Platforms](https://img.shields.io/badge/Platforms-Windows%20%F0%9F%AA%9F%20%7C%20%F0%9F%90%A7%20Linux-F7C59F?labelColor=0D1117)
![Programing languages](https://img.shields.io/badge/C++-027FDE?style=flat-square&logo=C%2B%2B&logoColor=white)  

**CppProjectBase** is a minimal **C++ template** designed to quickly bootstrap **cross-platform (Windows / Linux)** projects using **CMake** and **Conan**.  
It currently integrates SFML packages added via Conan, includes a simple `main.cpp`, a basic `CMakeLists.txt`, and build scripts for Windows and Linux.  
<br>

## ⚙️ Features & Goals
This repository serves as a **clean, modern foundation** for new C++ projects:
- ✅ Portable setup using **CMake**  
- 📦 Dependency management with **Conan**  
- ⚙️ Ready-to-use build scripts for **Windows** and **Linux**  
- 💡 Ideal for any C++ application
<br>

## 📁 Project Structure
| Path | Description |
|------|--------------|
| `CMakeLists.txt` | Main CMake configuration file |
| `conanfile.py` | Conan dependency definitions (includes SFML) |
| `src/` | Project source files |
| `scripts/` | Build helper scripts |
| `.gitignore` | Excludes build and temporary files |
<br>

## 🧰 Prerequisites

### 🪟 Windows
- [Python 3](https://www.python.org/downloads/) — required for Conan
- [CMake](https://cmake.org/download/) ≥ 3.27
- [Visual Studio](https://visualstudio.microsoft.com/) — with C++ desktop development tools   
 

### 🐧 Linux
- **GCC** (added with build essentials)
- **CMake** ≥ 3.27
- **Python 3**  
- **Make**
<br>

## 💻 Build an run Instructions
### 1. Clone the repository
```bash
git clone https://github.com/Cesca19/CppProjectBase.git
cd CppProjectBase
```
<br>

### 2. Launch the build scripts
Open your terminal at the root of the repository and launch the following commands

#### On Linux
```
  ./scripts/build_linux.sh
```

#### On Windows
```
  .\scripts\build_windows.bat
```
<br>

### 3. Execute the binaries
Ater a successful build, execute the binaries by launching the following commands

#### On Linux
```
  ./
```

#### On Windows
```
  .\
```
<br>

## 🗒️ Notes
* You can customize dependencies directly in `conanfile.py`.
* The build scripts automatically create and configure the `build/` directory.
* Ideal starting point for SFML, SDL, ImGui, boost or pure C++ projects.



