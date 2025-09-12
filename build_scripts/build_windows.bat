@echo off
setlocal

echo === Checking Python installation ===
python --version >nul 2>nul
if %errorlevel% neq 0 (
    echo Python not found. Please install it from https://www.python.org/downloads/
    echo Then close your command line, re-open it and relaunch the script.
    exit /b 1
) else (
    echo Python already installed.
)

echo === Checking pip installation    ===
python -m pip --version >nul 2>nul
if %errorlevel% neq 0 (
    echo pip not found. Installing...
    python -m ensurepip --upgrade
    python -m pip install --upgrade pip
) else (
    echo pip already installed.
)

echo === Checking CMake installation  ===
where cmake >nul 2>nul
if %errorlevel% neq 0 (
    echo CMake not found. Please install it from https://cmake.org/download/
    echo Then close your command line, re-open it and relaunch the script.
    exit /b 1
) else (
    echo CMake already installed.
)

echo === Checking Conan installation ===
where conan >nul 2>nul
if %errorlevel% neq 0 (
    echo Installing conan.
    pip install conan
    set "PATH=%USERPROFILE%\AppData\Roaming\Python\Python39\Scripts;%PATH%"
    conan install .. --output-folder=. --build=missing

    source ~/.profile
) else (
    echo Conan already installed.
)

echo === Configuring Conan profile ===
conan profile detect --force

echo === Creating build directory ===
if exist build rmdir /s /q build
mkdir build
cd build

echo === Installing dependencies with Conan ===
conan install .. --output-folder=. --build=missing

echo === Configuring project with CMake ===
cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release

echo === Building project ===
cmake --build . --config Release

echo  Build completed successfully (Windows)

endlocal
