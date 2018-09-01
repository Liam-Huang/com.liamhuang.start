function [gpsDatalatitude1,gpsDatalongitude1,presentTs] = importfile_gps_data(filename, startRow, endRow)
%IMPORTFILE2 ���ı��ļ��е���ֵ������Ϊ��ʸ�����롣
%   [GPSDATALATITUDE1,GPSDATALONGITUDE1,PRESENTTS] = IMPORTFILE2(FILENAME)
%   ��ȡ�ı��ļ� FILENAME ��Ĭ��ѡ����Χ�����ݡ�
%
%   [GPSDATALATITUDE1,GPSDATALONGITUDE1,PRESENTTS] = IMPORTFILE2(FILENAME,
%   STARTROW, ENDROW) ��ȡ�ı��ļ� FILENAME �� STARTROW �е� ENDROW ���е����ݡ�
%
% Example:
%   [gpsDatalatitude1,gpsDatalongitude1,presentTs] =
%   importfile2('gauss.gpsMsg_1804827.csv',2, 795);
%
%    ������� TEXTSCAN��

% �� MATLAB �Զ������� 2018/08/14 19:48:42

%% ��ʼ��������
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% ÿ���ı��еĸ�ʽ�ַ���:
%   ��1: ˫����ֵ (%f)
%	��2: ˫����ֵ (%f)
%   ��3: ˫����ֵ (%f)
% �й���ϸ��Ϣ������� TEXTSCAN �ĵ���
formatSpec = '%f%f%f%[^\n\r]';

%% ���ı��ļ���
fileID = fopen(filename,'r');

%% ���ݸ�ʽ�ַ�����ȡ�����С�
% �õ��û������ɴ˴������õ��ļ��Ľṹ����������ļ����ִ����볢��ͨ�����빤���������ɴ��롣
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% �ر��ı��ļ���
fclose(fileID);

%% ���޷���������ݽ��еĺ���
% �ڵ��������δӦ���޷���������ݵĹ�����˲�����������롣Ҫ�����������޷���������ݵĴ��룬�����ļ���ѡ���޷������Ԫ����Ȼ���������ɽű���

%% ����������������б�������
gpsDatalatitude1 = dataArray{:, 1};
gpsDatalongitude1 = dataArray{:, 2};
presentTs = dataArray{:, 3};

