function VarName1 = importfile(workbookFile,sheetName,startRow,endRow)
%IMPORTFILE 导入电子表格中的数据
%   VarName1 = IMPORTFILE(FILE) 读取名为 FILE 的 Microsoft Excel
%   电子表格文件的第一张工作表中的数据，并将该数据作为列矢量返回。
%
%   VarName1 = IMPORTFILE(FILE,SHEET) 从指定的工作表中读取。
%
%   VarName1 = IMPORTFILE(FILE,SHEET,STARTROW,ENDROW)
%   对于指定的行间隔从指定工作表中读取。对于不连续的行间隔，将 STARTROW 和 ENDROW
%   指定为大小匹配的一对标量或矢量。要读取到文件结尾，请为 inf 指定 ENDROW。%
% 示例:
%   VarName1 = importfile('安装前测试.xlsx','Sheet1',1,362);
%
%   另请参阅 XLSREAD。

% 由 MATLAB 自动生成于 2018/08/17 11:30:12

%% 输入处理

% 如果未指定工作表，则将读取第一张工作表
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% 如果未指定行的起点和终点，则会定义默认值。
if nargin <= 3
    startRow = 1;
    endRow = 362;
end

%% 导入数据
data = xlsread(workbookFile, sheetName, sprintf('A%d:A%d',startRow(1),endRow(1)));
for block=2:length(startRow)
    tmpDataBlock = xlsread(workbookFile, sheetName, sprintf('A%d:A%d',startRow(block),endRow(block)));
    data = [data;tmpDataBlock]; %#ok<AGROW>
end

%% 将导入的数组分配给列变量名称
VarName1 = data(:,1);

