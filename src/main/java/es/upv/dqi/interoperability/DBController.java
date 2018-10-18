package es.upv.dqi.interoperability;

import org.xmldb.api.base.Collection;
import org.xmldb.api.base.Database;
import org.xmldb.api.base.Resource;
import org.xmldb.api.base.ResourceIterator;
import org.xmldb.api.base.ResourceSet;
import org.xmldb.api.base.XMLDBException;
import org.xmldb.api.modules.XPathQueryService;

import java.nio.charset.Charset;

import javax.xml.transform.OutputKeys;

import org.exist.xmldb.EXistResource;
import org.exist.xmldb.RemoteBinaryResource;
import org.xmldb.api.DatabaseManager;

public class DBController {

	private static final String URI = "xmldb:exist://localhost:8080/exist/xmlrpc";
	private static final String DRIVER = "org.exist.xmldb.DatabaseImpl";
	
	static {
		try {
			Class<?> cl = Class.forName(DRIVER);
			Database database = (Database) cl.newInstance();
			database.setProperty("create-database", "true");
			DatabaseManager.registerDatabase(database);
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void listChildCollections(String parentCollection) {
		Collection col = null;
		try {
			col = DatabaseManager.getCollection(URI + parentCollection);
			col.setProperty(OutputKeys.INDENT,"yes");
			
			String [] childCollections = col.listChildCollections();
			
			for(String childCollection:childCollections) {
				System.out.println(childCollection);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(col!=null) {
				try {
					col.close();
				}catch(Exception e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	
	
	public static String loadResource(String collection, String resource) throws Exception {
		Collection col = null;
		RemoteBinaryResource res = null;
		String result = "";
		try {
			col = DatabaseManager.getCollection(URI+collection);
			col.setProperty(OutputKeys.INDENT, "yes");
			 res = (RemoteBinaryResource)col.getResource(resource);
			if(res == null) {
				System.out.println("Document "+resource+" not found in collection "+collection );
			} else {
				Object content = res.getContent();
				result = new String((byte[])content,Charset.forName("UTF-8"));
				System.out.println("Document "+resource+" in collection "+collection + ":\n"+result);
			}
		}catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(res!=null) {
				try {
					((EXistResource)res).freeResources();
				}catch(Exception e) {
					e.printStackTrace();
				}
			}
			if(col!=null) {
				try {
					col.close();
				}catch(Exception e) {
					e.printStackTrace();
				}
			}
		}
		return result;
	}
	

	public static String queryResource(String collection, String resource, String id) throws Exception {
		 Collection col = null;
		 String response = "";
	        try { 
	            col = DatabaseManager.getCollection(URI + collection );
		            XPathQueryService xpqs = (XPathQueryService)col.getService("XPathQueryService", "1.0");
	            xpqs.setProperty("indent", "yes");
	            String query = "//records/record[@id="+id+"]";
	            ResourceSet set = xpqs.queryResource(resource,query);
	            ResourceIterator i = set.getIterator();
	            Resource res = null;
	            
	            while(i.hasMoreResources()) {
	                try {
	                    res = i.nextResource();
	                    response += (String)res.getContent() + "\n"; 
	                } finally {
	                    //dont forget to cleanup resources
	                    try { ((EXistResource)res).freeResources(); } catch(XMLDBException xe) {xe.printStackTrace();}
	                }
	            }
	        } finally {
	            //dont forget to cleanup
	            if(col != null) {
	                try { col.close(); } catch(XMLDBException xe) {xe.printStackTrace();}
	            }
	        }
	        System.out.println("response -> " + response);
	        return response;
	}

}
