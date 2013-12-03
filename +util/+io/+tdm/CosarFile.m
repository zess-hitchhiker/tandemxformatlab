classdef CosarFile
    %CosarFile Representation of a *.cos-File
    %   Representation of a *.cos-File used for TerraSAR-X/TanDEM-X complex data
    
    %$Date: 2013-12-03 14:04:09 +0100 (Di, 03 Dez 2013) $, $Rev: 1020 $, $Author: behner $
    %Copyright 2013 Florian Behner and Simon Reuter
    %This file is part of the TerraSAR-X/TanDEM-X Toolbox for MATLAB.
    
    %The TerraSAR-X/TanDEM-X Toolbox for MATLAB is free software: you can
    %redistribute it and/or modify it under the terms of the GNU General
    %Public License as published by the Free Software Foundation, either
    %version 3 of the License, or (at your option) any later version.
    
    %The TerraSAR-X/TanDEM-X Toolbox for MATLAB is distributed in the hope
    %that it will be useful, but WITHOUT ANY WARRANTY; without even the
    %implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
    %PURPOSE. See the GNU General Public License for more details.
    
    %You should have received a copy of the GNU General Public License
    %along with the TerraSAR-X/TanDEM-X Toolbox for MATLAB. If not, see
    %http://www.gnu.org/licenses/.
    
    properties (SetAccess = private, GetAccess = private)
        fileId %File ID for file operation
        filename
        rangeLineTotalNumberOfBytes
        burstHeader
        conversionTable
        
    end % properties
    
    properties (SetAccess = private, GetAccess = public)
        formatVersion
        
        
    end % properties
    
    methods
        function obj = CosarFile(filename)
            % COSARFILE Opens *.cos-File and reads the Header.
            %   obj = CosarFile(filename) opens filename.
            
            obj.filename = filename;
            obj.fileId = fopen(obj.filename,'r','b');
            data = fread(obj.fileId, 20,'uint32');
            if (swapbytes(typecast(uint8('CSAR'),'uint32'))~=data(8))
                error(['Error: wrong format detected for file: ' obj.filename]);
                return
            end
            if obj.formatVersion == 2
                if data(13)~=1 || data(14)~=5 || data(15)~=10
                    error(['Error: wrong floating point format detected for file: ' obj.filename]);
                    return
                end
            end
            obj.formatVersion = data(9);
            obj.rangeLineTotalNumberOfBytes=data(6);
            obj.conversionTable=[];
            % Read Header Data
            
            seekerror=fseek(obj.fileId,0,'bof');
            positionBurst=0;
            while ~seekerror
                header = fread(obj.fileId,obj.rangeLineTotalNumberOfBytes/4,'uint32');
                bi=data(5);
                obj.burstHeader(bi).burstStartByte = positionBurst;
                obj.burstHeader(bi).burstLengthByte = header(1);
                obj.burstHeader(bi).lineLengthByte = header(6);
                obj.burstHeader(bi).index = header(5);
                obj.burstHeader(bi).rangeSamples = header(3);
                obj.burstHeader(bi).rangeSampleRelativeIndex = header(2);
                obj.burstHeader(bi).azimuthSamples = header(4);
                azimuthAnnotation= fread(obj.fileId,obj.rangeLineTotalNumberOfBytes/4,'uint32');
                obj.burstHeader(bi).azimuthSampleRelativeIndex = azimuthAnnotation(3:end);
                azimuthAnnotation= fread(obj.fileId,obj.rangeLineTotalNumberOfBytes/4,'uint32');
                obj.burstHeader(bi).azimuthSampleFirstValidIndex = azimuthAnnotation(3:end);
                azimuthAnnotation= fread(obj.fileId,obj.rangeLineTotalNumberOfBytes/4,'uint32');
                obj.burstHeader(bi).azimuthSampleLastValidIndex = azimuthAnnotation(3:end);
                positionBurst=positionBurst+header(1)+1;
                seekerror=fseek(obj.fileId,positionBurst,'bof');
            end
        end
        
        function nbrRangeSamples = getNbrRangeSamples(obj, burstId)
            % NBRRANGESAMPLES  Gets the number of range samples
            %   [data] = NBRRANGESAMPLES(burstId)
            %       gets the number of range samples of burst burstId
            %
            %   [data] = NBRRANGESAMPLES()
            %       gets the number of range Samples of the first burst
            
            if (nargin < 2)
                burstId = 1;
            end
            if (length(obj.burstHeader)<burstId)
                error(['Error: burstId (' num2str(burstId) ') exceeds number of bursts (' length(obj.burstHeader) ')']);
                return
            end
            
            nbrRangeSamples = obj.burstHeader(burstId).rangeSamples;
        end
        
        function nbrAzimuthSamples = getNbrAzimuthSamples(obj, burstId)
            % GETNBRAZIMUTHSAMPLES  Gets the number of azimuth samples
            %   [data] = GETNBRAZIMUTHSAMPLES(burstId)
            %       gets the number of azimuth samples of burst burstId
            %
            %   [data] = GETNBRAZIMUTHSAMPLES()
            %       gets the number of azimuth samples of the first burst
            
            if (nargin < 2)
                burstId = 1;
            end
            if (length(obj.burstHeader)<burstId)
                error(['Error: burstId (' num2str(burstId) ') exceeds number of bursts (' length(obj.burstHeader) ')']);
                return
            end
            
            nbrAzimuthSamples = obj.burstHeader(burstId).azimuthSamples;
        end
        
        function azimuthSampleRelativeIndex = getAzimuthSampleRelativeIndex(obj, burstId)
            % GETAZIMUTHSAMPLERELATIVEINDEX  Gets the relative index of the azimuth
            % samples
            %   [data] = GETAZIMUTHSAMPLERELATIVEINDEX(burstId)
            %       gets the relative index of of the azimuth samples of burst burstId
            %
            %   [data] = GETAZIMUTHSAMPLERELATIVEINDEX()
            %       gets the relative index of of the azimuth samples of the first burst
            %
            % See also GETNBRAZIMUTHSAMPLES,NBRRANGESAMPLES
            
            if (nargin < 2)
                burstId = 1;
            end
            if (length(obj.burstHeader)<burstId)
                error(['Error: burstId (' num2str(burstId) ') exceeds number of bursts (' length(obj.burstHeader) ')']);
                return
            end
            
            azimuthSampleRelativeIndex = obj.burstHeader(burstId).azimuthSampleRelativeIndex;
        end
        
        function [data,maskInvalid] = readRangeLines(obj,burstId, startIndex, n)
            % READRANGELINES  Reads COSAR Range Lines
            %   [data,maskInvalid] = READRANGELINES(burstId, start, n)
            %       reads n range lines of burst burstId starting from start.
            %
            %   [data,maskInvalid] = READRANGELINES(burstId,start)
            %       reads all range lines starting from start.
            %
            %   [data,maskInvalid] = READRANGELINES(burstId)
            %       reads all range lines of burst burstId.
            %
            %   [data,maskInvalid] = READRANGELINES()
            %       reads all range lines of the first burst.
            
            if obj.formatVersion == 2
                if isempty(obj.conversionTable)
                    obj.conversionTable=util.io.tdm.halfPrecisionToFloatTable();
                end
            end
            
            if (nargin < 2)
                burstId = 1;
            end
            
            if (length(obj.burstHeader)<burstId)
                error(['Error: burstId (' num2str(burstId) ') exceeds number of bursts (' length(obj.burstHeader) ')']);
                return
            end
            
            if (nargin < 3)
                startIndex = 1;
            end
            
            if (nargin < 4)
                n = obj.burstHeader(burstId).azimuthSamples - startIndex + 1;
            end
            
            if ((startIndex < 1) || (startIndex>obj.burstHeader(burstId).azimuthSamples))
                error(['Error: Index out of bounds (index=', num2str(startIndex), ').']);
            end
            
            if n > (obj.burstHeader(burstId).azimuthSamples - startIndex + 1)
                n = obj.burstHeader(burstId).azimuthSamples - startIndex + 1;
                warning(['Warning: Data request out of bounds (index=', num2str(startIndex), ').']);
            end
            
            offset = obj.burstHeader(burstId).burstStartByte+(startIndex+3)*obj.rangeLineTotalNumberOfBytes;
            fseek(obj.fileId,offset,'bof');
            if (obj.formatVersion == 2)
                data = fread(obj.fileId,[obj.rangeLineTotalNumberOfBytes/2, n],'*uint16');
                rangeSampleFirstValidIndex= double(typecast(reshape(flipdim(data(1:2,:),1),[],1),'uint32'))';
                rangeSampleLastValidIndex= double(typecast(reshape(flipdim(data(3:4,:),1),[],1),'uint32'))';
                data = obj.conversionTable(data(5:end,:)+1);
                data = complex(data(1:2:end,:),data(2:2:end,:));
            else
                data = fread(obj.fileId,[obj.rangeLineTotalNumberOfBytes/2, n],'*int16');
                rangeSampleFirstValidIndex= double(typecast(reshape(flipdim(data(1:2,:),1),[],1),'uint32'))';
                rangeSampleLastValidIndex= double(typecast(reshape(flipdim(data(3:4,:),1),[],1),'uint32'))';
                data = complex(single(data(5:2:end,:)),single(data(6:2:end,:)));
            end
            azimuthSampleFirstValidIndex=obj.burstHeader(burstId).azimuthSampleFirstValidIndex;
            azimuthSampleLastValidIndex=obj.burstHeader(burstId).azimuthSampleLastValidIndex;
            if (nargout > 1)
                [indexRange,indexAzimuth]=ndgrid(1:obj.burstHeader(burstId).rangeSamples,startIndex:(startIndex+n-1));
                maskInvalid=bsxfun(@lt,indexRange,rangeSampleFirstValidIndex);
                maskInvalid=maskInvalid | bsxfun(@gt,indexRange,rangeSampleLastValidIndex);
                maskInvalid=maskInvalid | bsxfun(@lt,indexAzimuth,azimuthSampleFirstValidIndex);
                maskInvalid=maskInvalid | bsxfun(@gt,indexAzimuth,azimuthSampleLastValidIndex);
            end
        end
        
        function delete(obj)
            % Delete methods are always called before a object
            % of the class is destroyed
            
            fclose(obj.fileId);
        end
    end  % methods
end
