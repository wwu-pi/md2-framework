package CurrentStateProject.backend.filedownload;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jboss.weld.exceptions.IllegalArgumentException;

import CurrentStateProject.backend.Config;

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
