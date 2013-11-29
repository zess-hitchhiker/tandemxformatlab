function [ data, colormap ] = readImageRasterFile( filename )
%readImageRasterFile Read SUN Image Raster File
%   Read SUN Image Raster File as specified in TD-GS-PS-3028
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

