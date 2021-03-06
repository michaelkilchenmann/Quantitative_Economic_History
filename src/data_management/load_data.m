clear
close all
%% Import data from text file.
% Script for importing data from the following text file:
%
%    /home/ulrichwoitek/Lehre/qwg2/Programme/2016/SQWG2016/bullionist_controversy.dat
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2016/03/15 16:08:04

%% Initialize variables.
filename = project_paths('IN_DATA','us.dat'); % better this way, as the path does not depend on the computer now
delimiter = ',';
startRow = 1;

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
CPI = dataArray{:, 1};
Industrial_Production = dataArray{:, 2};
%Year=(1700:(size(CPI,1)+1699))';
Month=(1:size(CPI,1))';
%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename =project_paths('OUT_DATA','us.mat'); % directory whre we want to save the data
eval(['save ' filename]); % Matlab command eval --> puts it into matlab and prompts: save filename
