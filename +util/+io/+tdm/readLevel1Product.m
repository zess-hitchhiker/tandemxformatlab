function docobject=readLevel1Product(filename)
    javaaddpath(fullfile(fileparts(mfilename('fullpath')),'class'));
        
    import java.lang.*
    import java.io.File
    import javax.xml.bind.*
    
    ofactory=de.dlr.tdm.level1product.ObjectFactory();
    context=JAXBContext.newInstance('de.dlr.tdm.level1product',ofactory.getClass.getClassLoader);
    marsh=context.createUnmarshaller;
    docobject=marsh.unmarshal(File(filename));
end
