%% Make Java JAXB binaries for the xml annotation

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

trafocall='xjc';
javacall='javac';

sourcepath=fullfile(fileparts(mfilename('fullpath')),'src');
classpath=fullfile(fileparts(mfilename('fullpath')),'class');


mkdir(sourcepath)
mkdir(classpath)

xsdpath=fileparts(mfilename('fullpath'));
xsdfiles={'cossc_product.xsd','de.dlr.tdm.cosscproduct'
    'level1Product.xsd','de.dlr.tdm.level1product'
    'geoReference.xsd','de.dlr.tdm.georeference'
    'antennaPhasePattern.xsd','de.dlr.tdm.antennaphasepattern'};


for xsd=xsdfiles';
    package=xsd{2};
    xsdfile=[xsdpath '\' xsd{1}];
    packagepath=strrep(package,'.','\');
    [passed,message]=system([ trafocall ' -d ' sourcepath ' -p ' package ' ' xsdfile]);
    if passed~=0
        error(message);
    end
    [passed,message]=system([ javacall ' -source 1.6 -target 1.6  -d ' classpath ' ' sourcepath '\' packagepath '\*.java']);
    message
    if passed~=0
        error(message);
    end
end