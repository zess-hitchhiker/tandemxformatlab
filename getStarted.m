%% Getting started with the TerraSAR-X / TanDEM-X Toolbox for MATLAB

%% Reading COSSC xml annotation
% Please provide the filename to the COSSC dataset first

[fileName, pathName] = uigetfile({'TDM*.xml','COSSC file'},'Please provide the filename to the COSSC dataset first');
cosscDocument = util.io.tdm.readCosscProduct(fullfile(pathName,fileName));


%% Reading Level1b xml annotation
% Please provide the filename to the COSSC dataset first

[fileName, pathName] = uigetfile({'TSX*.xml;TDX*.xml','TSX Level1b file'},'Please provide the filename to the Level1b dataset first');
level1bDocument = util.io.tdm.readLevel1Product(fullfile(pathName,fileName));

%% Reading COSAR data files
% Please provide the filename to the COSAR dataset first

[fileName, pathName] = uigetfile({'IMAGE*.cos','COSAR file'},'Please provide the filename to the COSAR dataset first');
cosarFile = util.io.tdm.CosarFile(fullfile(pathName,fileName));
cosarFile.getNbrAzimuthSamples
cosarFile.getNbrRangeSamples
%imageData=cosarFile.readRangeLines();
imageSection=cosarFile.readRangeLines(1,3000,1000);
imagesc(10*log10(abs(imageSection)));

%% Reading COSSC xml annotation
% Please provide the filename to the COSSC dataset first

[fileName, pathName] = uigetfile({'TDM*.xml','COSSC file'},'Please provide the filename to the COSSC dataset first');
cosscDocument = util.io.tdm.readCosscProduct(fullfile(pathName,fileName));

