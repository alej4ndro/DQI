package es.upv.dqi.interoperability;


import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("example-service")
public class ExampleService {

	@GET
	@Produces(MediaType.TEXT_PLAIN)
	@Path("get")
	public Response get(@QueryParam("id") String id) {
		
		System.out.println("Received incoming petition. Requested id: " + id);
		
		if (id == null) 
			return Response.status(400).entity("Requested id is null").build();
		
		DBController.listChildCollections("/db");
		
		String records = null;
		try {
			records = DBController.queryResource("/db/dqi-example","records2.xml",id);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return Response.ok("Received ID: " + id + "\n"+records).build();
	}
}
