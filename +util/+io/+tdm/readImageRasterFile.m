function [ data, colormap ] = readImageRasterFile( filename )
% READIMAGERASTERFILE Read SUN Image Raster File
%   Read SUN Image Raster File as specified in TD-GS-PS-3028
%   [ data, colormap ] = READIMAGERASTERFILE( filename )

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

try
    fid=fopen(filename,'r','b');
    header=fread(fid,8,'uint32');
    if header(1)~=1504078485
        error('Wrong Magic Number');
    end
    
    colormap=[];
    nCol=header(2);
    nRow=header(3);
    precision=header(4);
    %nBytes=header(5);
    dataType=header(6);
    colorMapType=header(7);
    colorMapLength=header(8);
    
    if colorMapType==1
        colormap=fread(fid,[colorMapLength/3,3],'uint8')/255;
    end
    
    precisionRead='*uint8';
    mformat='b';
    if dataType==99 && precision==32
        precisionRead='*single';
        mformat='l';
    end
    if dataType==101 && precision==16
        precisionRead='*uint16';
        mformat='b';
    end
    
    data=fread(fid,[nCol,nRow],precisionRead,0,mformat);
    fclose(fid);
catch
    fclose(fid);
end
end

