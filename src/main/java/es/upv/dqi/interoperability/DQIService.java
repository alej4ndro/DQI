package es.upv.dqi.interoperability;


import java.net.URI;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("dqi-service")
public class DQIService {

	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("ehr")
	public Response get(@QueryParam("patientId") String patientId) {
		
		System.out.println("Received incoming petition. Requested patient id: " + patientId);
		
		if (patientId == null) 
			return Response.status(400).entity("Requested id is null").build();
		
		DBController.listChildCollections("/db");
		
		String proprietaryRecord = null;
		String xquery = null;
		String normalizedRecord = null;
		try {
			proprietaryRecord = DBController.queryResource("/db/dqi","records.xml",patientId);
			xquery = DBController.loadResource("/db/dqi","mapping_script.xquery");
			normalizedRecord = XQuery.executeXQuery(xquery,proprietaryRecord);
			String tmpPath = XQuery.saveNormalizedRecord(patientId,normalizedRecord);
			if(tmpPath!=null)
				return Response.temporaryRedirect(new URI("/dqi/ehr/"+tmpPath)).build();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return Response.ok("Received ID: " + patientId 
							+ "\n Proprietary record:\n" + proprietaryRecord 
							+ "\n\n\n xquery script:\n\n" + xquery
							+ "\n\n\n normalized record:\n\n" + normalizedRecord).build();
	}
	
}
