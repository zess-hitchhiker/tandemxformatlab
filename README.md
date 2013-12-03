TerraSAR-X/TanDEM-X Toolbox for MATLAB
======================================

MATLAB tools to read TerraSAR-X/TanDEM-X datasets.  

Copyright 2013 Florian Behner and Simon Reuter.

This file is part of the TerraSAR-X/TanDEM-X Toolbox for MATLAB.

The TerraSAR-X/TanDEM-X Toolbox for MATLAB is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

The TerraSAR-X/TanDEM-X Toolbox for MATLAB is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with The TerraSAR-X/TanDEM-X Toolbox for MATLAB. If not, see http://www.gnu.org/licenses/.

What is provided by this toolset
================================

The TerraSAR-X/TanDEM-X Toolbox provides an MATLAB interface to read the data and annotation information delivered by the TanDEM-X mission operated by the German Aerospace Center (DLR). This dataset is specified as Level1b and COSSC product in the following documents which are reffered in the code as:
* `TX-GS-DD-3307` [Level 1b Product Format Specification](http://sss.terrasar-x.dlr.de/pdfs/TX-GS-DD-3307.pdf)
* `TD-GS-PS-3028` [TanDEM-X Experimental Product Description](https://tandemx-science.dlr.de/pdfs/TD-GS-PS-3028_TanDEM-X-Experimental-Product-Description_1.2.pdf)

Further information can be found at the operators websites:
* [TerraSAR-X Science Services](http://sss.terrasar-x.dlr.de "Further information concerning SAR image products")  
* [TanDEM-X Science Services](https://tandemx-science.dlr.de "Further information concerning interferometric SAR products")

Installation/Basic Usage
========================

Most users will add the folder structure for this package to their MATLAB path or their default workspace. Most modules are provided as MATLAB classes or Java classes with MATLAB wrapper functions. The toolbox makes use of [MATLAB packages](http://www.mathworks.de/de/help/matlab/matlab_oop/scoping-classes-with-packages.html) to create namespaces.

For usage of the toolbox consider the script `getStarted.m`(getStarted.m).

Function Overview
=================

###Reading TanDEM-X mission interferometric data###
####COSSC XML####
Read COSSC annotation files specified in `TD-GS-PS-3028` using:
```matlab
cosscDocument = util.io.tdm.readCosscProduct(fileName);
```
The function returns a Java Object representing the file content.
####Image Layer Info Text####
Read Image Layer Info annotation file specified in `TD-GS-PS-3028` using:
```matlab
iliDocument = util.io.tdm.readImageLayerInfo(fileName);
```
The function returns a Matlab struct representing the file content.
####Spectral Filter Frequency XML####
Read Spectral Filter Frequency annotation file specified in `TD-GS-PS-3028` using:
```matlab
sffDocument = util.io.tdm.readSpectralFilterFrequency(fileName);
```
The function returns a Matlab struct representing the xml tree.
####SUN raster data####
Read the SUN raster format as specified in `TD-GS-PS-3028` using:
```matlab
[rasFile, rasColorTable] = util.io.tdm.readImageRasterFile(fileName);
```
The function returns the indexed or floating point image and the colortable if available.

###Reading TerraSAR-X/TanDEM-X mission Level1b monostatic data###
####Level1b XML####
Read Level1b xml annotation files specified in `TX-GS-DD-3307` using:
```matlab
level1bDocument = util.io.tdm.readLevel1Product(fileName);
```
The function returns a Java Object representing the file content.
####Geo Reference XML####
Read Geo Reference annotation files specified in `TX-GS-DD-3307` using:
```matlab
georefDocument = util.io.tdm.readGeoReference(fileName);
```
The function returns a Java Object representing the file content.
####Antenna Phase Pattern XML####
Read Antenna Phase Pattern annotation files specified in `TX-GS-DD-3307` using:
```matlab
rfAntPatDocument = util.io.tdm.readAntennaPhasePattern(fileName);
```
The function returns a Java Object representing the file content.
####COSAR Image data####
Read COSAR image data files specified in `TX-GS-DD-3307` using:
```matlab
cosarFile = util.io.tdm.CosarFile(fileName);
% Get Information about the file
cosarFile.getNbrBursts
cosarFile.getNbrAzimuthSamples
cosarFile.getNbrRangeSamples
% Get the whole dataset of the first burst
imageData=cosarFile.readRangeLines();
% Get a portion of the dataset
[imageSection,imageInvalid]=cosarFile.readRangeLines(burstId,azimuthStartRead,nbrAzimuthRead);
```
The function returns a Matlab Object representing the file. The data is read through the ```readRangeLines()``` method.

Recompiling the Java class binaries
===================================
To recompile the binaries used to read the xml based annotion data you can invoke the skript `util.io.tdm.make.m`. Be sure that you have installed the `xjc` jaxb compiler and the `javac` Java compiler both provided by the `JDK`. Further you have to provide the xml stylesheets (xsl) included in the TanDEM-X datasets, for the xml files you want to read.
The stylesheets are configured in the make script. The precompiled classes are Java version 1.6, which is the current version shipped by MATLAB.
