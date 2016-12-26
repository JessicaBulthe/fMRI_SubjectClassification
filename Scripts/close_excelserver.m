% Function to close the excelserver

% JB - 2015


function close_excelserver(ExcelWorkbook, Excel)
ExcelWorkbook.Save
ExcelWorkbook.Close(false) % Close Excel workbook.
Excel.Quit;
delete(Excel);