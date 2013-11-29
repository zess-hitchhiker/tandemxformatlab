function f=halfPrecisionToFloatTable()
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
m=bitshift(i,13);
e=m;
e(:)=uint32(hex2dec('38800000'));

for ind=1:length(m)
while(~(bitand(m(ind),uint32(hex2dec('00800000'))))) % While not normalized
    e(ind)=e(ind)-uint32(hex2dec('00800000')); % Decrement exponent (1<<23)
    m(ind)=bitshift(m(ind),1); % Shift mantissa
end
end

m=bitand(m,bitcmp(uint32(hex2dec('00800000'))));
res= bitor(m,e); % Return combined number
end


