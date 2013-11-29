function docobject=readAntennaPhasePattern(filename)
    javaaddpath(fullfile(fileparts(mfilename('fullpath')),'class'));
        
    import java.lang.*
    import java.io.File
    import javax.xml.bind.*
    
    ofactory=de.dlr.tdm.antennaphasepattern.ObjectFactory();
    context=JAXBContext.newInstance('de.dlr.tdm.antennaphasepattern',ofactory.getClass.getClassLoader);
    marsh=context.createUnmarshaller;
    docobject=marsh.unmarshal(File(filename));
end
