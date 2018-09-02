%% clear screem
close all
clc
clear

%%  Import JPG image
filename = 'data_src\mydog.jpg';
data_mydog = importdata(filename);
image(data_mydog);

%% Import TXT file
filename = 'data_src\weeklydata.txt';
delimiterIn = ' ';
headerlinesIn = 1;
data_weeklydata = importdata(filename,delimiterIn,headerlinesIn);
% View data
for k = 1:7
   disp(data_weeklydata.colheaders{1, k});
   disp(data_weeklydata.data(:, k));
   disp(' ');
end

%%
filename = 'data_src\weatherReport.txt';
rows = 7;
cols = 5;

% open the file
fid = fopen(filename);

% read the file headers, find M (number of months)
M = fscanf(fid, '%*s %*s\n%*s %*s %*s %*s\nM=%d\n\n', 1);

% read each set of measurements
for n = 1:M
   mydata(n).time = fscanf(fid, '%s', 1);
   mydata(n).month = fscanf(fid, '%s', 1);

   % fscanf fills the array in column order,
   % so transpose the results
   mydata(n).raindata  = ...
      fscanf(fid, '%f', [rows, cols]);
end
for n = 1:M
   disp(mydata(n).time);
   disp(mydata(n).month);
   disp(mydata(n).raindata);
end

% close the file
fclose(fid);

