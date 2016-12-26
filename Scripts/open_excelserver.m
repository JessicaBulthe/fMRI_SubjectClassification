% function to open the excel server

% JB - 2015

function [Excel, ExcelWorkbook] = open_excelserver(file)

% open excel
Excel = actxserver ('Excel.Application');
if ~exist(file,'file')
   ExcelWorkbooks = Excel.workbooks.Add;
   ExcelWorkbooks.SaveAs(file,1);
   ExcelWorkbooks.Close(false);
end
ExcelWorkbook = Excel.Workbooks.Open(file);
