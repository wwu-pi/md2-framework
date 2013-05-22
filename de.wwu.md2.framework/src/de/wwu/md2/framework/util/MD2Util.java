package de.wwu.md2.framework.util;

import java.io.IOException;
import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.Set;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.xtext.EcoreUtil2;
import org.eclipse.xtext.resource.IResourceDescription;
import org.eclipse.xtext.resource.IResourceDescriptions;
import org.eclipse.xtext.resource.impl.ResourceDescriptionsProvider;

import com.google.common.base.Joiner;
import com.google.common.collect.Sets;
import com.google.inject.Inject;

import de.wwu.md2.framework.generator.IExtendedFileSystemAccess;
import de.wwu.md2.framework.mD2.MD2Model;

/**
 * This util class offers helper methods for the MD2 framework development.
 */
public class MD2Util {
	
	@Inject
	ResourceDescriptionsProvider resourceDescriptionsProvider;
	
	private static Set<Resource> resources;
	
	/**
	 * Set of all keywords that are allowed in a controller.
	 * 
	 * TODO Re-implement either by auto-generating via MWE2 workflow or by finding a fast and reliable way to extract them on the fly.
	 */
	public static final Set<String> CONTROLLER_KEYWORDS = Sets.newHashSet("action", "remoteConnection", "event", "main", "validator", "workflow", "contentProvider");
	
	/**
	 * Set of all keywords that are allowed in a model.
	 * 
	 * TODO Re-implement either by auto-generating via MWE2 workflow or by finding a fast and reliable way to extract them on the fly.
	 */
	public static final Set<String> MODEL_KEYWORDS = Sets.newHashSet("entity", "enum");
	
	/**
	 * Set of all keywords that are allowed in a view.
	 * 
	 * TODO Re-implement either by auto-generating via MWE2 workflow or by finding a fast and reliable way to extract them on the fly.
	 */
	public static final Set<String> VIEW_KEYWORDS = Sets.newHashSet("style", "Spacer", "Image", "Button", "TextInput", "AutoGeneratorPane",
			"OptionInput", "Tooltip", "Label", "GridLayoutPane", "FlowLayoutPane", "AlternativesPane");
	
	/**
	 * Returns the package name that is being derived from the URI path of the corresponding file.
	 * 
	 * @param uri URI of the resource.
	 * @return Name of the package that has been derived from the resource path.
	 */
	public String getPackageNameFromPath(URI uri) {
		Joiner joiner = Joiner.on(".");
		String[] pathSegments = uri.path().split("/");
		
		int from = firstOccurenceOfElement(pathSegments, "src") + 1;
		int to =  pathSegments.length - 1; //-1 to cut-off the file name which is not part of the package
		String[] target = Arrays.copyOfRange(pathSegments, from, to);
		
		return joiner.join(target);
	}
	
	/**
	 * Returns the index of the first occurence of {@code element} in an array.
	 * 
	 * @param arr Array of any type.
	 * @param element Element that should be found in the array.
	 * @return The index of {@code element} in the given array or -1 if the array does not contain {@code element}.
	 */
	public <T> int firstOccurenceOfElement(T[] arr, T element) {
		int pos = 0;
		for(T t : arr) {
			if(t.equals(element)) return pos;
			pos++;
		}
		return -1;
	}
	
	/**
	 * Returns a List with the resources of all models in a project.
	 * 
	 * @param resourceSet
	 * @return List with the resources of all models.
	 */
	public Collection<Resource> getAllResources(final Resource resource) {
		
		Set<Resource> resources = Sets.newHashSet();
		ResourceSet resourceSet = resource.getResourceSet();
		EcoreUtil2.resolveAll(resourceSet);
		IResourceDescriptions resourceDescriptions = resourceDescriptionsProvider.createResourceDescriptions();
		
		for (IResourceDescription resourceDescription : resourceDescriptions.getAllResourceDescriptions()) {
			Resource resourceFromDescription = resourceSet.getResource(resourceDescription.getURI(), true);
			if(resourcesBelongToSameProject(resource, resourceFromDescription)) {
				resources.add(resourceFromDescription);
			}
		}
		
		// resource cache handling
		if(resources.isEmpty() && MD2Util.resources == null) {
			// The resource provider register has not been updated, yet. (e.g. after a project clean up)
			// => populate the result set with the current model
			resources.add(resource);
		} else if(resources.isEmpty() && MD2Util.resources != null) {
			resources = MD2Util.resources;
		}
		
		assert !resources.isEmpty() : "The resource set should not be empty at this point.";
		MD2Util.resources = resources;
		
		return resources;
	}
	
	/**
	 * Checks whether two resources belong to the same project. This check is performed
	 * using the PlatformURI.
	 * 
	 * @param r1 Resource 1.
	 * @param r2 Resource 2.
	 * @return True if r1 and r2 belong to the same project. Otherwise false.
	 */
	public boolean resourcesBelongToSameProject(Resource r1, Resource r2) {
		return r1.getURI().path().split("/")[2].equals(r2.getURI().path().split("/")[2]);
	}
	
	/**
	 * Generates a list of all MD2Model objects. Therefore first all resources are loaded. In a second step
	 * the first EObject of the content of each model is being taken as it is assumed that it contains the
	 * MD2Model object.
	 * 
	 * @return List of all MD2Model objects.
	 */
	public Collection<MD2Model> getAllMD2Models(Resource resource) {
		ArrayList<MD2Model> lst = new ArrayList<MD2Model>();
		
		// generate list of all models
		for(Resource res : getAllResources(resource)) {
			EObject o = res.getContents().get(0);
			assert o instanceof MD2Model : "Instance is expected to be of type MD2Model";
			lst.add((MD2Model)o);
		}
		
		return lst;
	}
	
	/**
	 * Finds a resource with a given name. This helper method takes a file name and path (relative
	 * to the /resources/ directory) and returns an input stream for the file.
	 * 
	 * @param file File name. File paths have to be relative to the base directory /resources/.
	 * @return Input stream for the given file.
	 */
	public static InputStream getSystemResource(final String file) {
		return MD2Util.class.getResourceAsStream("/resources/" + file.replaceFirst("^(\\.)?/(resources/)?", new String()));
	}
	
	/**
	 * Extract the archive of the given input stream into the given directory.
	 * @param archive Input stream containing a ZIP archive.
	 * @param folder The folder into which the contents of the archive will be extracted. 
	 *	Empty directories within the ZIP file will be ignored.
	 * @param fsa Access to the file system.
	 */
	public static void extractArchive(InputStream archive, String folder, IExtendedFileSystemAccess fsa) {
		ZipInputStream zip = new ZipInputStream(archive);
		ZipEntry cur;
		if(!folder.endsWith("/"))
			folder = folder + "/";
		try {
			while((cur = zip.getNextEntry()) != null) {
				extractEntry(cur, zip, folder, fsa);
			}
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}
	
	/**
	 * Extract a single entry from the zip archive of zipStream.
	 * @param entry The entry to extract. If it is an directory, the entry will be skipped.
	 * @param zipStream The stream currently positioned at the entry.
	 * @param folder The target folder.
	 * @param fsa Access to the file system, used to generate the file.
	 */
	private static void extractEntry(ZipEntry entry, final ZipInputStream zipStream, String folder, IExtendedFileSystemAccess fsa) {
		if(entry.isDirectory())
			// do not create empty directories, others will implicitly be created by contained files
			return;
		
		// Input stream that acts as a proxy to the zip input stream, needed because generateFileFromInputStream will close the stream given as a parameter
		InputStream entryStream = new InputStream() {
			@Override
			public int read() throws IOException {
				return zipStream.read();
			}
			
			@Override
			public int read(byte[] b, int off, int len) throws IOException {
				return zipStream.read(b, off, len);
			}
		};
		fsa.generateFileFromInputStream(entryStream, folder + entry.getName());
	}
	
	/**
	 * Tries to parse a string representing a date with a given DateFormat. Returns an according Date object if the string
	 * is parsable. Othwerise null is returned.
	 * 
	 * @param input Date string to parse.
	 * @param format SimpleDateFormat that should be used for parsing.
	 * @return A date object or null if string is not parsable.
	 */
	public static Date tryToParse(String input, SimpleDateFormat format) {
		Date date = null;
		try {
			date = format.parse(input);
		} catch (ParseException e) {}
		return date;
	}
	
}
