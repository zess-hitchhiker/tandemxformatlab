%% Getting started with the TerraSAR-X / TanDEM-X Toolbox for MATLAB

% $Date: 2013-12-03 08:48:07 +0100 (Di, 03 Dez 2013) $, $Rev: 1017 $, $Author: behner $
% Copyright 2013 Florian Behner and Simon Reuter
% This file is part of the TerraSAR-X/TanDEM-X Toolbox for MATLAB.

% The TerraSAR-X/TanDEM-X Toolbox for MATLAB is free software: you can
% redistribute it and/or modify it under the terms of the GNU General
% Public License as published by the Free Software Foundation, either
% version 3 of the License, or (at your option) any later version.

% The TerraSAR-X/TanDEM-X Toolbox for MATLAB is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the
% implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.

% You should have received a copy of the GNU General Public License along
% with the TerraSAR-X/TanDEM-X Toolbox for MATLAB. If not, see
% http://www.gnu.org/licenses/.


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

%[fileName, pathName] = uigetfile({'IMAGE*.cos','COSAR file'},'Please provide the filename to the COSAR dataset first');
cosarFile = util.io.tdm.CosarFile(fullfile(pathName,fileName));
cosarFile.getNbrAzimuthSamples
cosarFile.getNbrRangeSamples
imageData=cosarFile.readRangeLines();
[imageSection,imageInvalid]=cosarFile.readRangeLines(1,3000,1000);
imagesc(10*log10(abs(imageSection)));

%% Reading COSSC xml annotation
% Please provide the filename to the COSSC dataset first

[fileName, pathName] = uigetfile({'TDM*.xml','COSSC file'},'Please provide the filename to the COSSC dataset first');
cosscDocument = util.io.tdm.readCosscProduct(fullfile(pathName,fileName));

