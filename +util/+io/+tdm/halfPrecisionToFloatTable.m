function f=halfPrecisionToFloatTable()
% HALFPRECISIONTOFLOATTABLE Create IEEE 754-2008 half-precision to
%   single-precision conversion look up table
%   LUT=HALFPRECISIONTOFLOATTABLE()
%
%   See also Test 

% $date$, $rev$, $author$
% Copyright 2013 Florian Behner and Simon Reuter
% This file is part of the TerraSAR-X/TanDEM-X Toolbox for MATLAB.
% The TerraSAR-X/TanDEM-X Toolbox for MATLAB is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
% The TerraSAR-X/TanDEM-X Toolbox for MATLAB is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with the TerraSAR-X/TanDEM-X Toolbox for MATLAB. If not, see http://www.gnu.org/licenses/.

% This code is based on the algorithm presented by Jeroen van der Zijp in [Fast Half Float Conversions](ftp://www.fox-toolkit.org/pub/fasthalffloatconversion.pdf)

[mantissatable,exponenttable,offsettable]=createfloatlut();
h=uint32(0:(2^16-1));
t=bitshift(h,-10)+1;
f=typecast(mantissatable(1+offsettable(t)+bitand(h,uint32(hex2dec('3ff'))))+exponenttable(t),'single');
end

function [mantissatable,exponenttable,offsettable]=createfloatlut()
mantissatable(1)=uint32(0);
mantissatable(2:1024)=convertmantissa(uint32(1:1023));
mantissatable(1025:2048)=uint32(hex2dec('38000000'))+(bitshift((uint32(1024:2047)-1024),13));

exponenttable(1)=uint32(0);
exponenttable(2:31)=bitshift(uint32(1:30),23);
exponenttable(32)  = uint32(hex2dec('47800000'));
exponenttable(33)  = uint32(hex2dec('80000000'));
exponenttable(34:63)=uint32(hex2dec('80000000'))+(bitshift((uint32(33:62)-32),23));
exponenttable(64)  = uint32(hex2dec('C7800000'));

offsettable(1:64)=uint32(1024);
offsettable(1)=0;
offsettable(33)=0;

end

function res=convertmantissa(i)
mantissa=bitshift(i,13);
exponent=mantissa;
exponent(:)=uint32(hex2dec('38800000')); %Start with exponent offset

for ind=1:length(mantissa)
while(~(bitand(mantissa(ind),uint32(hex2dec('00800000'))))) % While not normalized
    exponent(ind)=exponent(ind)-uint32(hex2dec('00800000')); % Decrement exponent (1<<23)
    mantissa(ind)=bitshift(mantissa(ind),1); % Shift mantissa
end
end

mantissa=bitand(mantissa,bitcmp(uint32(hex2dec('00800000')))); % Clear leading one
res= bitor(mantissa,exponent); % Return combined number
end


