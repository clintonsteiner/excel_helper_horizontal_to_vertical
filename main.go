package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"github.com/xuri/excelize/v2"
)

func main() {
	outputMode := flag.String("output", "newsheet", "Output mode: 'newsheet' (add to same file) or 'newfile' (create separate file)")
	sheetName := flag.String("sheet", "", "Name of the sheet to convert (if empty, uses 'Provided Data' or first sheet with data)")
	flag.Parse()

	args := flag.Args()
	if len(args) == 0 {
		fmt.Println("Usage: excel_converter [flags] <input.xlsx>")
		fmt.Println("\nFlags:")
		fmt.Println("  -output string")
		fmt.Println("    \tOutput mode: 'newsheet' or 'newfile' (default \"newsheet\")")
		fmt.Println("  -sheet string")
		fmt.Println("    \tName of the sheet to convert (default: 'Provided Data')")
		os.Exit(1)
	}

	inputFile := args[0]

	// Validate output mode
	if *outputMode != "newsheet" && *outputMode != "newfile" {
		log.Fatal("Invalid output mode. Use 'newsheet' or 'newfile'")
	}

	// Read input file
	wb, err := excelize.OpenFile(inputFile)
	if err != nil {
		log.Fatalf("Failed to open file: %v", err)
	}
	defer wb.Close()

	// Determine sheet name to convert
	sourceSheet := *sheetName
	if sourceSheet == "" {
		sourceSheet = "Provided Data"
	}

	// Convert data
	convertedData, err := convertProvidedDataToRequiredFormat(wb, sourceSheet)
	if err != nil {
		log.Fatalf("Failed to convert data: %v", err)
	}

	// Output result
	if *outputMode == "newsheet" {
		err = writeToNewSheet(wb, convertedData, inputFile)
	} else {
		err = writeToNewFile(convertedData, inputFile)
	}

	if err != nil {
		log.Fatalf("Failed to write output: %v", err)
	}

	fmt.Println("✓ Conversion completed successfully!")
}

func convertProvidedDataToRequiredFormat(wb *excelize.File, sheetName string) ([][]interface{}, error) {
	// Read the specified sheet
	rows, err := wb.GetRows(sheetName)
	if err != nil {
		return nil, fmt.Errorf("failed to read '%s' sheet: %v", sheetName, err)
	}

	if len(rows) < 3 {
		return nil, fmt.Errorf("'%s' sheet has insufficient data (needs at least 3 rows)", sheetName)
	}

	// Parse headers (Row 1) - metric categories (repeated for each month)
	metricHeadersRow := rows[0][3:] // Skip first 3 columns

	// Parse sub-headers (Row 2) - months
	subHeaders := rows[1]

	// Extract months - they appear in the sub-headers starting from column D (index 3)
	months := subHeaders[3:]

	// Identify unique metrics and their column positions
	uniqueMetrics := []string{}
	metricFirstCol := map[string]int{} // Track first column for each metric

	for colIdx, metric := range metricHeadersRow {
		metric = strings.TrimSpace(metric)
		if metric != "" && !contains(uniqueMetrics, metric) {
			uniqueMetrics = append(uniqueMetrics, metric)
			metricFirstCol[metric] = colIdx
		}
	}

	// Data rows start from row 3
	dataRows := rows[2:]

	// Build output: one row per project per month
	var output [][]interface{}

	// Add header row
	header := []interface{}{
		"Project Number - Name",
		"Project Num",
		"Project Name",
		"Category",
		"Client",
		"Project Manager",
		"Date",
		"Date Order",
		"PFM Date",
		"Month-Year",
	}

	// Add unique metric categories as headers
	for _, metric := range uniqueMetrics {
		header = append(header, metric)
	}

	output = append(output, header)

	// Process data rows
	for _, dataRow := range dataRows {
		if len(dataRow) < 3 {
			continue
		}

		projectName := strings.TrimSpace(dataRow[0])
		if projectName == "" {
			continue
		}

		client := dataRow[1]
		projectManager := dataRow[2]

		// Extract project number from project name (e.g., "123456 - Client Project" -> "123456")
		projectNum := extractProjectNumber(projectName)

		// Process each month
		for monthIdx := 0; monthIdx < len(months); monthIdx++ {
			month := strings.TrimSpace(months[monthIdx])
			if month == "" {
				continue
			}

			// Create output row
			outputRow := []interface{}{
				projectName,
				projectNum,
				extractProjectNameOnly(projectName),
				"", // Category - would need to be filled from source data if available
				client,
				projectManager,
				"", // Date - would need to be parsed from month
				monthIdx + 1, // Date Order (month number)
				parseMonthToDate(month),
				month,
			}

			// Add data values for this month (for each unique metric)
			for _, metric := range uniqueMetrics {
				// Find the column for this metric in this month
				metricBaseCol := metricFirstCol[metric]
				dataColIdx := 3 + metricBaseCol + monthIdx

				if dataColIdx < len(dataRow) {
					val := dataRow[dataColIdx]
					// Try to convert to number if possible
					if val != "" {
						if numVal, err := strconv.ParseFloat(val, 64); err == nil {
							outputRow = append(outputRow, numVal)
						} else {
							outputRow = append(outputRow, val)
						}
					} else {
						outputRow = append(outputRow, val)
					}
				} else {
					outputRow = append(outputRow, nil)
				}
			}

			output = append(output, outputRow)
		}
	}

	return output, nil
}

func contains(slice []string, item string) bool {
	for _, v := range slice {
		if v == item {
			return true
		}
	}
	return false
}

func extractProjectNumber(projectName string) interface{} {
	parts := strings.Split(projectName, " - ")
	if len(parts) > 0 {
		numStr := strings.TrimSpace(parts[0])
		if num, err := strconv.ParseFloat(numStr, 64); err == nil {
			return num
		}
		return numStr
	}
	return projectName
}

func extractProjectNameOnly(projectName string) string {
	parts := strings.Split(projectName, " - ")
	if len(parts) > 1 {
		return strings.TrimSpace(parts[1])
	}
	return projectName
}

func parseMonthToDate(monthStr string) string {
	// Parse format like "Jan 26" to a date string "2026-01-01"
	monthStr = strings.TrimSpace(monthStr)
	parts := strings.Fields(monthStr)
	if len(parts) != 2 {
		return ""
	}

	monthName := parts[0]
	yearStr := parts[1]

	months := map[string]int{
		"Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6,
		"Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12,
	}

	monthNum, ok := months[monthName]
	if !ok {
		return ""
	}

	year, err := strconv.Atoi(yearStr)
	if err != nil {
		return ""
	}

	// Assume 20xx for 2-digit years
	if year < 100 {
		year += 2000
	}

	date := time.Date(year, time.Month(monthNum), 1, 0, 0, 0, 0, time.UTC)
	return date.Format("2006-01-02")
}

func writeToNewSheet(wb *excelize.File, data [][]interface{}, inputFile string) error {
	// Create new sheet
	sheetName := "Converted Data"
	_, err := wb.NewSheet(sheetName)
	if err != nil {
		return err
	}

	// Write data to sheet
	for rowIdx, row := range data {
		for colIdx, val := range row {
			cell, _ := excelize.CoordinatesToCellName(colIdx+1, rowIdx+1)
			wb.SetCellValue(sheetName, cell, val)
		}
	}

	// Save to same file
	err = wb.SaveAs(inputFile)
	if err != nil {
		return err
	}

	fmt.Printf("Data written to new sheet '%s' in %s\n", sheetName, inputFile)
	return nil
}

func writeToNewFile(data [][]interface{}, inputFile string) error {
	// Create new workbook
	newWb := excelize.NewFile()
	sheetName := "Converted Data"

	// Write data to sheet
	for rowIdx, row := range data {
		for colIdx, val := range row {
			cell, _ := excelize.CoordinatesToCellName(colIdx+1, rowIdx+1)
			newWb.SetCellValue(sheetName, cell, val)
		}
	}

	// Generate output filename
	dir := filepath.Dir(inputFile)
	nameWithExt := filepath.Base(inputFile)
	name := strings.TrimSuffix(nameWithExt, filepath.Ext(nameWithExt))
	outputFile := filepath.Join(dir, name+"_converted.xlsx")

	// Save new file
	err := newWb.SaveAs(outputFile)
	if err != nil {
		return err
	}

	fmt.Printf("Data written to new file: %s\n", outputFile)
	return nil
}
