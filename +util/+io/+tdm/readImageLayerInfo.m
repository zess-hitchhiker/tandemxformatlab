function [ data, types ] = readImageLayerInfo( filename )
%readImageLayerInfo Reads Image Layer Info Textfile
%   Reads Image Layer Info Textfile
try
    fs=fopen(filename,'r');
    dat=textscan(fs,'%s %s %s\n');
    
    data=cell2struct(dat{3},dat{1});
    types=cell2struct(dat{2},dat{1});
    
    fclose(fs);
catch
    fclose(fs);
end
end

