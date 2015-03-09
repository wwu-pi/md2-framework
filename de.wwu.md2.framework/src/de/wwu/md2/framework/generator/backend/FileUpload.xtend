package de.wwu.md2.framework.generator.backend

class FileUpload {
    
    def static createFileUploadWS(String basePackageName)'''
        package «basePackageName».ws;
        
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
        
        import «basePackageName».Config;
        
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
    '''
    
    
    def static createDownloadServlet(String basePackageName)'''
        package «basePackageName».filedownload;
        
        import java.io.File;
        import java.io.FileInputStream;
        import java.io.IOException;
        import java.io.OutputStream;
        import java.nio.file.Path;
        import java.nio.file.Paths;
        
        import javax.servlet.ServletException;
        import javax.servlet.annotation.WebServlet;
        import javax.servlet.http.HttpServlet;
        import javax.servlet.http.HttpServletRequest;
        import javax.servlet.http.HttpServletResponse;
        
        import org.jboss.weld.exceptions.IllegalArgumentException;
        
        import «basePackageName».Config;
        
        /**
         * Servlet implementation class DownloadServlet
         */
        @WebServlet("/DownloadFile")
        public class DownloadServlet extends HttpServlet {
            private static final long serialVersionUID = 1L;
               
            /**
             * @see HttpServlet#HttpServlet()
             */
            public DownloadServlet() {
                super();
                // TODO Auto-generated constructor stub
            }
        
            /**
             * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
             */
            protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
                String fileName = request.getParameter("file");
                if (fileName == null) {
                    throw new ServletException("You have to supply a file name using ?file=");
                }
                // TODO check validity of filename!
                Path filePath = Paths.get(Config.UPLOAD_FILE_STORAGE_PATH.toString(), Config.UPLOAD_FILE_PREFIX + fileName);
                
                // for example application/pdf, text/plain, text/html, image/jpg
                response.setContentType("image/jpg");
        
                // Make sure to show the download dialog
                //response.setHeader("Content-disposition","attachment; filename=yourcustomfilename.pdf");
        
                File my_file = new File(filePath.toString());
        
                // This should send the file to browser
                OutputStream out = response.getOutputStream();
                FileInputStream in = new FileInputStream(my_file);
                byte[] buffer = new byte[4096];
                int length;
                while ((length = in.read(buffer)) > 0){
                   out.write(buffer, 0, length);
                }
                in.close();
                out.flush();
            }
        }
    '''
}
