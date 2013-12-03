function [ spectralFilterFrequencyDocument ] = readSpectralFilterFrequency( filename )
%READSPECTRALFILTERFREQUENCY Reads the spectral filter frequency xml annotation
%   spectralFilterFrequencyDocument = READSPECTRALFILTERFREQUENCY( filename )
%   

% $Date: 2013-12-02 11:46:49 +0100 (Mo, 02 Dez 2013) $, $Rev: 1007 $, $Author: behner $
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
    tree = xmlread(filename);
catch
    error('Failed to read XML file %s.',filename);
end

% Recurse over child nodes. This could run into problems
% with very deeply nested trees.
try
    spectralFilterFrequencyDocument = parseChildNodes(tree);
catch err
    error('Unable to parse XML file %s.',filename);
end

% ----- Local function PARSECHILDNODES -----
function theStruct = parseChildNodes(theNode)
% Recurse over node children.
theStruct=struct();
if theNode.hasChildNodes
    childNodes = theNode.getChildNodes;
    numChildNodes = childNodes.getLength;
    for count = 1:numChildNodes
        theChild = childNodes.item(count-1);
        [name,content]=makeStructFromNode(theChild);
        if ~strcmp(name,'#text')
            if ~isfield(theStruct,name)
                theStruct.(name)=content;
            else
                theStruct.(name)(end+1)=content;
            end
        else
            if numChildNodes==1
                theStruct=content;
            end
        end
    end
end

% ----- Local function MAKESTRUCTFROMNODE -----
function [nodeName,nodeStruct] = makeStructFromNode(theNode)
% Create structure of node info.
nodeName=char(theNode.getNodeName);
if theNode.hasChildNodes
    nodeStruct = parseChildNodes(theNode);
else
    nodeStruct = char(theNode.getTextContent);
end

if theNode.hasAttributes
    nodeStruct.attributes=parseAttributes(theNode);
end

% ----- Local function PARSEATTRIBUTES -----
function attributes = parseAttributes(theNode)
% Create attributes structure.
theAttributes = theNode.getAttributes;
numAttributes = theAttributes.getLength;
for count = 1:numAttributes
    attrib = theAttributes.item(count-1);
    attributes.(char(attrib.getName))=char(attrib.getValue);
end
