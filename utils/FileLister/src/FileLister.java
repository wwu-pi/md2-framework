
import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
 
public class FileLister {
	
	public static void main(String[] args) {
		
		StringBuilder pngs = new StringBuilder();
		StringBuilder staticFiles = new StringBuilder();
		File folder = new File(args[0]);
		File[] listOfFiles = folder.listFiles();
		
		// Step 1 -- clear target folders
		delete(new File(folder + "/static_files"));
		delete(new File(folder + "/generated_files"));
		
		// Step 2 -- List and copy png images
		for (int i = 0; i < listOfFiles.length; i++) {
			if (listOfFiles[i].isFile() && listOfFiles[i].getName().endsWith(".png")) {
				pngs.append("\"").append(listOfFiles[i].getName()).append("\", ");
				pngs.append("\n");
				
				//copy file
				copyFile(listOfFiles[i].getName(), "static_files", args[0]);
			}
		}
		pngs.deleteCharAt(pngs.length() - 3);
		
		
		// Step 3 -- list and copy static files
		for (int i = 0; i < listOfFiles.length; i++) {
			try {
				if (listOfFiles[i].isFile() && (listOfFiles[i].getName().endsWith(".h") || listOfFiles[i].getName().endsWith(".m"))) {
					FileInputStream fstream = new FileInputStream(listOfFiles[i].getAbsoluteFile());
				
					DataInputStream in = new DataInputStream(fstream);
					BufferedReader br = new BufferedReader(new InputStreamReader(in));
					String ln = br.readLine();
					
					if(ln.matches("\\s*//\\s*static:.*")) {
						//System.out.println(ln);
						ln = ln.replaceFirst("\\s*//\\s*static:\\s*", "").trim();
						staticFiles.append("StaticFiles.put(\"").append(listOfFiles[i].getName()).append("\", \"" + ln + "\");\n");
						copyFile(listOfFiles[i].getName(), "static_files", args[0]);
					}
					else {
						copyFile(listOfFiles[i].getName(), "generated_files", args[0]);
					}
					
					in.close();
				}
				else if (listOfFiles[i].isFile() && (listOfFiles[i].getName().endsWith(".pch") || listOfFiles[i].getName().endsWith(".plist"))) {
					// copy and rename
					copyFile(listOfFiles[i].getName(), "static_files", args[0]);
					File f = new File(args[0] + "/static_files/" + listOfFiles[i].getName());
			        if (f.exists()) {
			            f.renameTo(new File(args[0] + "/static_files/" + listOfFiles[i].getName().replace("TariffCalculator-", "")));
			        }
				}
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		System.out.println(pngs);
		System.out.println();
		System.out.println(staticFiles);
		
	}
	
	/**
	 * Copy file to target folder
	 * @param fileName
	 * @param targetFolder
	 * @param baseFolder
	 */
	private static void copyFile(String fileName, String targetFolder, String baseFolder) {
		
		// check if target dir exists
		File folder = new File(baseFolder + "/" + targetFolder);
		if(!folder.exists()) {
			folder.mkdir();
		}
		
		// copy file
		File inputFile = new File(baseFolder + "/" + fileName);
		File outputFile = new File(baseFolder + "/" + targetFolder + "/" + fileName);
		try {
			FileInputStream in = new FileInputStream(inputFile);
			FileOutputStream out = new FileOutputStream(outputFile);
			int c;
			
			while ((c = in.read()) != -1)
				out.write(c);
			
			in.close();
			out.close();
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}
	
	/**
	 * Recursive file remover
	 * @param f
	 */
	private static void delete(File f) {
		
		if(!f.exists()) {
			return;
		}
		
		if (f.isDirectory()) {
			for (File c : f.listFiles()) {
				delete(c);
			}
		}
		
		f.delete();
	}
	
}
