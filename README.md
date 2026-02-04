# Excel Converter - Horizontal to Vertical Format

A Go program that converts Excel data from horizontal format (wide layout with many columns) to vertical format (tall layout with many rows).

## Features

- Converts "Provided Data" sheet to "Required Format" layout
- Transforms data from horizontal (metrics as columns) to vertical (one row per project per month)
- Two output modes:
  - **newsheet** (default): Adds converted data as a new sheet in the same Excel file
  - **newfile**: Creates a new separate Excel file with converted data

## Quick Start (No Go Required)

### Windows

1. **Download the pre-built executable:**
   - Download `excel_converter.exe` from this folder

2. **Run the program:**
   ```bash
   excel_converter.exe "C:\path\to\your\file.xlsx"
   ```

   Or with custom output mode:
   ```bash
   excel_converter.exe -output newfile "C:\path\to\your\file.xlsx"
   ```

3. **Or use the batch file (easier):**
   ```bash
   convert.bat "C:\path\to\your\file.xlsx"
   ```

### macOS/Linux

1. **Download the appropriate executable:**
   - macOS: `excel_converter` (for Intel or Apple Silicon - compile from source)
   - Linux: Compile from source (see below)

2. **Run the program:**
   ```bash
   ./excel_converter "path/to/your/file.xlsx"
   ```

   Or with custom output mode:
   ```bash
   ./excel_converter -output newfile "path/to/your/file.xlsx"
   ```

## Command-Line Options

```
Usage: excel_converter [flags] <input.xlsx>

Flags:
  -output string
      Output mode: 'newsheet' (add to same file) or 'newfile' (create separate file)
      (default "newsheet")

  -sheet string
      Name of the sheet to convert
      (default "Provided Data")
```

### Examples

**Add converted data to a new sheet in the same file (from "Provided Data" sheet):**
```bash
excel_converter.exe "data.xlsx"
```
Output: `data.xlsx` with new sheet "Converted Data"

**Convert a differently-named sheet:**
```bash
excel_converter.exe -sheet "Raw Data" "data.xlsx"
```

**Create a separate output file:**
```bash
excel_converter.exe -output newfile "data.xlsx"
```
Output: `data_converted.xlsx`

**Convert a specific sheet and create separate output:**
```bash
excel_converter.exe -sheet "Sales Data" -output newfile "data.xlsx"
```
Output: `data_converted.xlsx`

## What the Program Does

The program reads the "Provided Data" sheet which has:
- Horizontal layout (metrics as column headers)
- Multiple columns for each metric (one per month: Jan 26, Feb 26, etc.)

And converts it to "Required Format" with:
- Vertical layout (one row per project per month)
- All metrics as separate columns
- Organized columns: Project Number, Project Name, Client, Project Manager, Date, Month-Year, followed by all metrics

## Building from Source (Advanced)

If you want to build the executable yourself or for a different platform:

### Prerequisites
- [Go 1.20+](https://golang.org/dl/) installed

### Build Steps

1. Clone or download this repository
2. Navigate to the project directory
3. Run:
   ```bash
   go build -o excel_converter.exe
   ```

   For macOS:
   ```bash
   go build -o excel_converter
   ```

   For Linux:
   ```bash
   go build -o excel_converter
   ```

4. The executable will be created in the current directory

## Troubleshooting

### "File not found" error
- Make sure you provide the full path to your Excel file
- On Windows: Use backslashes `\` or forward slashes `/` in the path
- Enclose paths with spaces in quotes: `"path with spaces\file.xlsx"`

### "Failed to open file" error
- Ensure the Excel file exists and is readable
- The file should not be open in Excel

### "Failed to read 'Provided Data' sheet" error
- Make sure the Excel file has a sheet named exactly "Provided Data"
- The sheet must have at least 3 rows of data

### Output file not created
- Check that you have write permissions in the directory
- For "newsheet" mode, the original file will be modified
- For "newfile" mode, a new file will be created in the same directory

## Example Workflow

```batch
REM Navigate to the folder containing the files
cd C:\Users\YourName\Documents\ExcelFiles

REM Run the converter
excel_converter.exe -output newfile "Sales Data.xlsx"

REM Check the output
REM A new file "Sales Data_converted.xlsx" will be created
```

## Technical Details

- **Language**: Go (Golang)
- **Excel Library**: excelize (github.com/xuri/excelize/v2)
- **Supported File Format**: .xlsx (Excel 2007+)
- **Platform Support**: Windows, macOS, Linux (with pre-built or compiled executables)

## License

This tool is provided as-is for data conversion purposes.
