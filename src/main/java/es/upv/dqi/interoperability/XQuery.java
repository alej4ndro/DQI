package es.upv.dqi.interoperability;

import java.io.StringReader;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.input.SAXBuilder;
import org.jdom2.output.XMLOutputter;

import net.sf.saxon.Configuration;
import net.sf.saxon.query.DynamicQueryContext;
import net.sf.saxon.query.StaticQueryContext;
import net.sf.saxon.query.XQueryExpression;

public class XQuery {

	private static final String STYLED_XML_HEADER = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><?xml-stylesheet type=\"text/xsl\" href=\"en13606.xslt\"?>";
	private static final String COMPOSITION_STR = "COMPOSITION";
	private static final String ENTRY_STR = "ENTRY";
	private static final String CLUSTER_STR = "CLUSTER";
	private static final String ELEMENT_STR = "ELEMENT";
	private static final String SECTION_STR = "SECTION";
	private static final String FOLDER_STR = "FOLDER";
	
	public static final String executeXQuery(String xquery, String instance){
		String result = null;
		
		if(xquery == null || xquery.isEmpty() || instance == null || instance.isEmpty())
			return result;
		
		try {
			Map<String,String> args = new HashMap<String,String>();
			args.put("in", ".*");
			result = xquery(xquery,instance,args);
		}catch(Exception e) {
			result = null;
			e.printStackTrace();
		}
		
		return result;
	}
	
	public static final String saveNormalizedRecord(String patientId, String normalizedRecord) {
		String result = null;
		if(normalizedRecord == null || normalizedRecord.isEmpty())
			return result;
		
		SAXBuilder builder = new SAXBuilder();
		Document doc;
		try {
			doc = builder.build(new StringReader(normalizedRecord));
			Element root = searchMainComponent(doc.getRootElement());
			XMLOutputter outp = new XMLOutputter();
			String content = STYLED_XML_HEADER + "\n" + outp.outputString(root);
			java.nio.file.Path tmp = Files.createTempFile("normalized-ehr-patient-id-"+patientId, ".xml");
			Files.write(tmp, content.getBytes(StandardCharsets.UTF_8));
			result = tmp.getFileName().toString();
			Files.move(tmp, Paths.get(DQIService.class.getClassLoader().getResource("").toURI()).getParent().getParent().resolve("ehr").resolve(result));
		} catch (Exception e) {
			result = null;
			e.printStackTrace();
		}
		
		return result;
	}

	
	private static final String xquery(String xquery, String instance, Map<String,String> args){
	    XQueryExpression exp =null;
	    String result = "";
	    try{
	        Configuration config = new Configuration();
	        StaticQueryContext sqc = new StaticQueryContext(config,true);
	        
	        exp = sqc.compileQuery(xquery);
	        DynamicQueryContext dynamicContext = new DynamicQueryContext(config);
	        for(String k:args.keySet()){
	        	dynamicContext.setParameter(k,args.get(k));
	        }
	        dynamicContext.setContextItem(config.buildDocument(new StreamSource(new StringReader(instance))));
	        Properties prop= new Properties();
	        prop.setProperty(OutputKeys.INDENT,"yes");
	        StringWriter sw = new StringWriter();
	        exp.run(dynamicContext,new StreamResult(sw) , prop ); 
	        result = sw.getBuffer().toString();
	    }catch(Exception e){
	        e.printStackTrace();
	    }
	    return result; 
	}
	
	
	private static final Element searchMainComponent(Element element) {
		Element result = null;
		
		if(element == null)
			return result;
		
		if(element.getName().compareTo(COMPOSITION_STR) == 0
				||element.getName().compareTo(ENTRY_STR) == 0
				||element.getName().compareTo(FOLDER_STR) == 0
				||element.getName().compareTo(SECTION_STR) == 0
				||element.getName().compareTo(ELEMENT_STR) == 0
				||element.getName().compareTo(CLUSTER_STR) == 0)
			result = element;
		else if(element.getChildren() != null)
			for(Element child:element.getChildren()) 
				if((result = searchMainComponent(child)) != null)
					break;
		return result;
	}
}
