@echo off
REM Excel Converter - Windows Batch Script
REM Usage: convert.bat "path\to\file.xlsx" [output_mode]
REM        output_mode: newsheet (default) or newfile

setlocal enabledelayedexpansion

if "%~1"=="" (
    echo.
    echo Excel Converter - Horizontal to Vertical Format
    echo.
    echo Usage: convert.bat "path\to\file.xlsx" [newsheet^|newfile]
    echo.
    echo Examples:
    echo   convert.bat "C:\Users\YourName\Documents\data.xlsx"
    echo   convert.bat "data.xlsx" newfile
    echo.
    exit /b 1
)

set "input_file=%~1"
set "output_mode=newsheet"

if not "%~2"=="" (
    set "output_mode=%~2"
)

REM Check if file exists
if not exist "!input_file!" (
    echo Error: File not found: !input_file!
    exit /b 1
)

echo Converting Excel file...
echo Input: !input_file!
echo Output mode: !output_mode!
echo.

excel_converter.exe -output !output_mode! "!input_file!"

if errorlevel 1 (
    echo.
    echo Error during conversion. Make sure:
    echo - The file is not open in Excel
    echo - The file contains a "Provided Data" sheet
    exit /b 1
)

echo.
echo Conversion completed successfully!
echo.

if "!output_mode!"=="newfile" (
    for %%F in ("!input_file!") do (
        set "name=%%~nF"
        set "drive=%%~dF"
        set "path=%%~pF"
    )
    for /f "delims=." %%A in ("!name!") do set "nameonly=%%A"
    echo Output file: !drive!!path!!nameonly!_converted.xlsx
) else (
    echo Output sheet: "Converted Data" (added to same file)
)

echo.
pause
