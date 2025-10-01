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

echo %blue%[INFO] Configuring project with CMake%white%
cd build
cmake .. -DCMAKE_BUILD_TYPE=Debug

echo %blue%[INFO] Building project%white%
cmake --build . --config Debug

:: echo %green%[OK] Build completed successfully (Windows)%white%


:: if exist .conan_intall_dir rmdir /s /q build
:: md .conan_intall_dir
:: python -m pip install conan --target .\.conan_intall_dir\ --upgrade
:: set conan_exe_dir=%cd% + .conan_intall_dir\
:: echo conan exe dir is %conan_exe_dir=%cd%%
:: 
:: 
:: 
:: 
:: 
endlocal