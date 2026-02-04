@echo off
REM Build script for Excel Converter
REM Builds executables for all platforms on Windows

setlocal enabledelayedexpansion

echo ========================================
echo Building Excel Converter
echo ========================================
echo.

REM Check if Go is installed
go version >nul 2>&1
if errorlevel 1 (
    echo Error: Go is not installed or not in PATH
    echo Download Go from: https://golang.org/dl/
    exit /b 1
)

REM Create build directory
if exist build rmdir /s /q build
mkdir build

echo Removing old build files...
if exist excel_converter.exe del excel_converter.exe
if exist excel_converter_macos_intel del excel_converter_macos_intel
if exist excel_converter_macos_arm64 del excel_converter_macos_arm64
if exist excel_converter_linux del excel_converter_linux
echo.

REM Windows
echo Building for Windows (x64)...
set GOOS=windows
set GOARCH=amd64
go build -o build\excel_converter.exe
if errorlevel 1 (
    echo Build failed!
    exit /b 1
)
echo Done - build\excel_converter.exe created
echo.

REM macOS Intel
echo Building for macOS (Intel)...
set GOOS=darwin
set GOARCH=amd64
go build -o build\excel_converter_macos_intel
if errorlevel 1 (
    echo Build failed!
    exit /b 1
)
echo Done - build\excel_converter_macos_intel created
echo.

REM macOS Apple Silicon
echo Building for macOS (Apple Silicon/M1/M2/M3)...
set GOOS=darwin
set GOARCH=arm64
go build -o build\excel_converter_macos_arm64
if errorlevel 1 (
    echo Build failed!
    exit /b 1
)
echo Done - build\excel_converter_macos_arm64 created
echo.

REM Linux
echo Building for Linux (x64)...
set GOOS=linux
set GOARCH=amd64
go build -o build\excel_converter_linux
if errorlevel 1 (
    echo Build failed!
    exit /b 1
)
echo Done - build\excel_converter_linux created
echo.

REM Reset environment
set GOOS=
set GOARCH=

REM Copy supporting files
echo Copying supporting files...
copy convert.bat build\ >nul
copy README.md build\ >nul
copy HOW_TO_SHARE.md build\ >nul
echo Done
echo.

REM Summary
echo ========================================
echo Build complete!
echo ========================================
echo.
echo Files in build\ directory:
dir /b build\
echo.
echo Next steps:
echo   1. Test the executables
echo   2. Push to GitHub: git push origin main
echo   3. Create a release tag: git tag v1.0.0 ^&^& git push origin v1.0.0
echo.
pause
