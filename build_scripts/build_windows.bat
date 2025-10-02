@echo off

setlocal
set "green=[32m"
set "blue=[36m"
set "yellow=[33m"
set "red=[31m"
set "white=[0m"

echo %blue%[INFO] Checking Python installation%white%
python --version >nul 2>nul
if %errorlevel% neq 0 (
    echo %red%[ERROR] Python not found. Please install it from https://www.python.org/downloads/%white%
    echo %red%[ERROR] Then close your command line, re-open it and relaunch the script.%white%
    exit /b 1
) else (
    echo %green%[OK] Python already installed.%white%
)

echo %blue%[INFO] Checking pip installation%white%
python -m pip --version >nul 2>nul
if %errorlevel% neq 0 (
    echo %yellow%[WARN] pip not found. Installing...%white%
    python -m ensurepip --upgrade
    python -m pip install --upgrade pip
) else (
    echo %green%[OK] pip already installed.%white%
)

echo %blue%[INFO] Checking CMake installation%white%
where cmake >nul 2>nul
if %errorlevel% neq 0 (
    echo %red%[ERROR] CMake not found. Please install it from https://cmake.org/download/%white%
    echo %red%[ERROR] Then close your command line, re-open it and relaunch the script.%white%
    exit /b 1
) else (
    echo %green%[OK] CMake already installed.%white%
)

echo %blue%[INFO] Checking Conan installation%white%
call "./build_scripts/conan_installer.bat"

echo %blue%[INFO] Configuring Conan profile%white%
conan profile detect --force

echo %blue%[INFO] Installing dependencies with Conan%white%
conan install . 
if %errorlevel% neq 0 (
    echo %red%[ERROR] Conan install failed.%white%
    exit /b 1
)

echo %blue%[INFO] Configuring project with CMake%white%
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release  -DCMAKE_RUNTIME_OUTPUT_DIRECTORY=bin
if %errorlevel% neq 0 (
    echo %red%[ERROR] CMake configuration failed.%white%
    exit /b 1
)

echo %blue%[INFO] Building project%white%
cmake --build . --config Release
if %errorlevel% neq 0 (
    echo %red%[ERROR] Build failed .%white%
    exit /b 1
)
echo %green%[OK] Build completed successfully (Windows)%white%

endlocal