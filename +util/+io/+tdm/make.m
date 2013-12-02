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