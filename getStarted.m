%% Getting started with the TerraSAR-X / TanDEM-X Toolbox for MATLAB

% $Date: 2013-12-03 14:04:09 +0100 (Di, 03 Dez 2013) $, $Rev: 1020 $, $Author: behner $
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

%% Reading TanDEM-X COSSC datasets
% Starting with the COSSC xml annotation
% Please provide the filename to the COSSC dataset first

[fileName, pathName] = uigetfile({'TDM*.xml','COSSC file'},...
    'Please provide the filename to the COSSC dataset first');

cosscDocument = util.io.tdm.readCosscProduct(fullfile(pathName,fileName));

cosscDocument.getCommonAcquisitionInfo.getAcquisitionGeometry.getHeightOfAmbiguity
cosscCornerCoordinates=cosscDocument.getCommonSceneInfo.getSceneCornerCoord.toArray;
[ccLat,ccLon,ccIncAngle]=arrayfun(@(cc)...
    deal(cc.getLat, cc.getLon, cc.getIncidenceAngle),cosscCornerCoordinates);

%% Reading ImageLayerInfo annotation
% Please provide the filename to the GeoReference dataset first

[fileName, pathName] = uigetfile({'image_layer_info.txt','ILI file'},...
    'Please provide the filename to the ILI dataset first');

iliDocument = util.io.tdm.readImageLayerInfo(fullfile(pathName,fileName));

iliDocument.image_layer_beam_sat1
iliDocument.image_layer_beam_sat2

%% Reading SpectralFilterFrequency annotation
% Please provide the filename to the GeoReference dataset first

[fileName, pathName] = uigetfile({'spectral_filter_frequencies.xml',...
    'SFF file'},'Please provide the filename to the SFF dataset first');

sffDocument = util.io.tdm.readSpectralFilterFrequency(fullfile(pathName,fileName));

sffDocument.spectralShiftFilter_Block.scene.numberRangeBlocks
sffDocument.spectralShiftFilter_Block.scene.numberAzimuthBlocks

%% Reading RasterImage files
% Please provide the filename to the GeoReference dataset first

[fileName, pathName] = uigetfile({'*.flt',...
    'Floating point raster image file';'*.ras','fixed point raster image file'},...
    'Please provide the filename to the RAS dataset first');

[rasFile, rasColorTable] = util.io.tdm.readImageRasterFile(fullfile(pathName,fileName));
if ~isempty(rasColorTable)
    rasColorImage=rasColorTable(rasFile+1,:);
    rasColorImage=reshape(rasColorImage,[size(rasFile),3]);
end

%% Reading TerraSAR-X/TanDEM-X Level1b datasets
% Starting with the Level1b xml annotation
% Please provide the filename to the Level1b dataset first

[fileName, pathName] = uigetfile({'TSX*.xml;TDX*.xml','TSX Level1b file'},...
    'Please provide the filename to the Level1b dataset first');

level1bDocument = util.io.tdm.readLevel1Product(fullfile(pathName,fileName));

nbrStates=level1bDocument.getPlatform.getOrbit.getOrbitHeader.getNumStateVectors;
orbitStates=level1bDocument.getPlatform.getOrbit.getStateVec.toArray;
[orbitPositionX,orbitPositionY,orbitPositionZ,orbitTime]=arrayfun(@(pos)...
    deal(pos.getPosX, pos.getPosY, pos.getPosZ ,...
    pos.getTimeGPS.doubleValue+pos.getTimeGPSFraction),orbitStates);

%% Reading GeoReference xml annotation
% Please provide the filename to the GeoReference dataset first

[fileName, pathName] = uigetfile({'GEOREF.xml','GEOREF file'},...
    'Please provide the filename to the GEOREF dataset first');

georefDocument = util.io.tdm.readGeoReference(fullfile(pathName,fileName));

geoRefGeoGridNbrRange=georefDocument.getGeolocationGrid.get(0).getNumberOfGridPoints.getRange;
geoRefGeoGridNbrAzimuth=georefDocument.getGeolocationGrid.get(0).getNumberOfGridPoints.getAzimuth;

geoRefGeoGrid=georefDocument.getGeolocationGrid.get(0).getGridPoint.toArray;
[geoGridLat,geoGridLon,geoGridHeight]=arrayfun(@(pos)...
    deal(pos.getLat, pos.getLon, pos.getHeight.doubleValue ...
    ),geoRefGeoGrid);
geoGridLat=reshape(geoGridLat,geoRefGeoGridNbrRange,geoRefGeoGridNbrAzimuth);
geoGridLon=reshape(geoGridLon,geoRefGeoGridNbrRange,geoRefGeoGridNbrAzimuth);
geoGridHeight=reshape(geoGridHeight,geoRefGeoGridNbrRange,geoRefGeoGridNbrAzimuth);
surface(geoGridLon,geoGridLat,geoGridHeight)

%% Reading AntennaPhasePattern xml annotation
% Please provide the filename to the AntennaPhasePattern dataset first

[fileName, pathName] = uigetfile({'RFANTPAT*.xml','AntennaPhasePattern file'},...
    'Please provide the filename to the AntennaPhasePattern dataset first');

rfAntPatDocument = util.io.tdm.readAntennaPhasePattern(fullfile(pathName,fileName));

rfAntPatDocument.getPolLayer
rfAntPatDocument.getBeamID
antennaPattern=rfAntPatDocument.getPhase.toArray;
[antennaAngle,antennaPhaseValue]=arrayfun(@(phase)...
    deal(phase.getAngle, phase.getValue ...
    ),antennaPattern);
plot(antennaAngle,antennaPhaseValue)

%% Reading COSAR data files
% Please provide the filename to the COSAR dataset first

[fileName, pathName] = uigetfile({'IMAGE*.cos','COSAR file'},...
    'Please provide the filename to the COSAR dataset first');

cosarFile = util.io.tdm.CosarFile(fullfile(pathName,fileName));

cosarFile.getNbrAzimuthSamples
cosarFile.getNbrRangeSamples
imageData=cosarFile.readRangeLines();
[imageSection,imageInvalid]=cosarFile.readRangeLines(1,3000,1000);
imagesc(10*log10(abs(imageSection)));


