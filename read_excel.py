import openpyxl
import json

# Load the Excel file
wb = openpyxl.load_workbook('now integrate to  a full inventory.xlsx')
ws = wb.active

print(f"Sheet name: {ws.title}")
print(f"Dimensions: {ws.dimensions}")
print("\nFirst 10 rows:\n")

# Get all data
data = []
for idx, row in enumerate(ws.iter_rows(values_only=True)):
    if idx < 10:
        print(f"Row {idx}: {row}")
    data.append(row)

print(f"\nTotal rows: {len(data)}")
print(f"\nHeaders: {data[0]}")
