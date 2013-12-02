%% Getting started with the TerraSAR-X / TanDEM-X Toolbox for MATLAB

%% Reading COSSC xml annotation
% Please provide the filename to the COSSC dataset first

[fileName, pathName] = uigetfile({'TDM*.xml','COSSC file'},'Please provide the filename to the COSSC dataset first');
cosscDocument = util.io.tdm.readCosscProduct(fullfile(pathName,fileName));


%% SECTION TITLE
% DESCRIPTIVE TEXT
