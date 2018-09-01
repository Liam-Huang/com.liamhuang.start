function VarName1 = importfile(workbookFile,sheetName,startRow,endRow)
%IMPORTFILE ������ӱ���е�����
%   VarName1 = IMPORTFILE(FILE) ��ȡ��Ϊ FILE �� Microsoft Excel
%   ���ӱ���ļ��ĵ�һ�Ź������е����ݣ�������������Ϊ��ʸ�����ء�
%
%   VarName1 = IMPORTFILE(FILE,SHEET) ��ָ���Ĺ������ж�ȡ��
%
%   VarName1 = IMPORTFILE(FILE,SHEET,STARTROW,ENDROW)
%   ����ָ�����м����ָ���������ж�ȡ�����ڲ��������м������ STARTROW �� ENDROW
%   ָ��Ϊ��Сƥ���һ�Ա�����ʸ����Ҫ��ȡ���ļ���β����Ϊ inf ָ�� ENDROW��%
% ʾ��:
%   VarName1 = importfile('��װǰ����.xlsx','Sheet1',1,362);
%
%   ������� XLSREAD��

% �� MATLAB �Զ������� 2018/08/17 11:30:12

%% ���봦��

% ���δָ���������򽫶�ȡ��һ�Ź�����
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% ���δָ���е������յ㣬��ᶨ��Ĭ��ֵ��
if nargin <= 3
    startRow = 1;
    endRow = 362;
end

%% ��������
data = xlsread(workbookFile, sheetName, sprintf('A%d:A%d',startRow(1),endRow(1)));
for block=2:length(startRow)
    tmpDataBlock = xlsread(workbookFile, sheetName, sprintf('A%d:A%d',startRow(block),endRow(block)));
    data = [data;tmpDataBlock]; %#ok<AGROW>
end

%% ����������������б�������
VarName1 = data(:,1);

