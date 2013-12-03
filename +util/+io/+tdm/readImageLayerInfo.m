function data = readImageLayerInfo( filename )
% READIMAGELAYERINFO Reads Image Layer Info Textfile
%     data = READIMAGELAYERINFO( filename )

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

try
    fs=fopen(filename,'r');
    dat=textscan(fs,'%s %s %s\n');
    
    fieldnames=dat{1};
    values=cellfun(@parseValue,dat{2},dat{3},'UniformOutput',false);
    data=cell2struct(values,fieldnames);
    
    fclose(fs);
catch err
    fclose(fs);
    rethrow(err);
end

function matlabValue=parseValue(type,value)
switch type
    case 'INT_32'
        matlabValue=str2double(value);
    case 'STR'
        matlabValue=value(2:end-1);
    otherwise
        error('Datatype not known');
end



