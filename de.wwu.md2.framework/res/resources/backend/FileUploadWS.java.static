package CurrentStateProject.backend.ws;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.ejb.Stateless;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.glassfish.jersey.media.multipart.FormDataContentDisposition;
import org.glassfish.jersey.media.multipart.FormDataParam;

import CurrentStateProject.backend.Config;

@Path("/upload")
@Stateless
public class FileUploadWS {


	@POST
	@Path("/file")
	@Consumes(MediaType.MULTIPART_FORM_DATA)
	public Response uploadFile(
			@FormDataParam("file") InputStream uploadedInputStream,
			@FormDataParam("file") FormDataContentDisposition fileDetail) {

		// save it
		try {
			File targetLocation = File.createTempFile(Config.UPLOAD_FILE_PREFIX, "", Config.UPLOAD_FILE_STORAGE_PATH);
			
			writeToFile(uploadedInputStream, targetLocation);

			String output = targetLocation.getName().substring(Config.UPLOAD_FILE_PREFIX.length()); // get the generated part of the filename and return it to the server.

			return Response.ok().entity("{\"name\": \""+output+"\"}").header("MD2-Model-Version", Config.MODEL_VERSION).build();
		} catch (IOException e) {
			e.printStackTrace();
			// TODO alternativ: { "error" : "abcd" }
			return Response.serverError().header("MD2-Model-Version", Config.MODEL_VERSION).build();
		}

	}

	// save uploaded file to new location
	private void writeToFile(InputStream uploadedInputStream,
			File uploadedFileLocation) throws IOException {

		OutputStream out = new FileOutputStream(uploadedFileLocation);
		int read = 0;
		byte[] bytes = new byte[1024];

		while ((read = uploadedInputStream.read(bytes)) != -1) {
			out.write(bytes, 0, read);
		}
		out.flush();
		out.close();

	}

}
