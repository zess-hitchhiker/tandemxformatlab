function docobject=readCosscProduct(filename)
    javaaddpath(fullfile(fileparts(mfilename('fullpath')),'class'));
        
    import java.lang.*
    import java.io.File
    import javax.xml.bind.*
    
    ofactory=de.dlr.tdm.cosscproduct.ObjectFactory();
    context=JAXBContext.newInstance('de.dlr.tdm.cosscproduct',ofactory.getClass.getClassLoader);
    marsh=context.createUnmarshaller;
    docobject=marsh.unmarshal(File(filename));
end
