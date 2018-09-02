%% clear screem
close all
clc
clear
%%
x = (0:0.01:2*pi)';
y = sin(x);
data = [x,y];

%% method1: save
save 'data_src\data_export_method1.txt' data -ascii;

%% method2: dlmwrite
filename2 = 'data_src\data_export_method2.txt';
dlmwrite(filename2, data, ' ');

%% method3:
filename3 = 'data_src\data_export_method3.xls';
xlswrite(filename3, data);

%% method4:
filename4 = 'data_src\data_export_method4.txt';
% open a file for writing
fid = fopen(filename4, 'w');

% Table Header
fprintf(fid, 'x              sin(x)\n');

% print values in column order
% two values appear on each row of the file
fprintf(fid, '%1.4f    %1.4f\n', data);
fclose(fid);
