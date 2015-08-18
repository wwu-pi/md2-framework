package de.wwu.md2.framework.generator.ios.util;

import com.google.common.collect.Sets
import com.google.common.io.Files
import java.io.File
import java.io.IOException
import java.util.Collection

class FileSystemUtil {
	
	/**
	 * Recursively copy a file or directory.
	 * 
	 * @param sourceLocation
	 * @param targetLocation
	 * @throws IOException
	 */
	def static Collection<String> copyDirectory(File sourceLocation, File targetLocation) throws IOException {
		val copiedFiles = Sets.newHashSet();
		
		if (sourceLocation.isDirectory()) {
			if (!targetLocation.exists()) {
				targetLocation.mkdir();
			}
			
			sourceLocation.list().forEach[child |
				copiedFiles.addAll(copyDirectory(new File(sourceLocation, child), new File(targetLocation, child)));
			]
		} else {
			Files.copy(sourceLocation, targetLocation)
			copiedFiles.add(targetLocation.absolutePath);
		}
		
		return copiedFiles;
	}
	
	def static createParentDirs(File file) {
		Files.createParentDirs(file)
	}
}