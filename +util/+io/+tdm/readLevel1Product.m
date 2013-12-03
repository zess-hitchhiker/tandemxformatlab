function docobject=readLevel1Product(filename)
% READLEVEL1PRODUCT Read XML annotation file
%   docobject=READLEVEL1PRODUCT(filename)

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

javaaddpath(fullfile(fileparts(mfilename('fullpath')),'class'));

import java.lang.*
import java.io.File
import javax.xml.bind.*

ofactory=de.dlr.tdm.level1product.ObjectFactory();
context=JAXBContext.newInstance('de.dlr.tdm.level1product',ofactory.getClass.getClassLoader);
marsh=context.createUnmarshaller;
docobject=marsh.unmarshal(File(filename));
end
