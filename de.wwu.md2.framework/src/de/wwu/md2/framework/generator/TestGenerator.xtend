package de.wwu.md2.framework.generator

import com.google.inject.Inject
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ContentElement
import de.wwu.md2.framework.mD2.OptionInput
import de.wwu.md2.framework.mD2.TextInput
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.util.Scanner
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.xtext.naming.IQualifiedNameProvider

import static extension de.wwu.md2.framework.generator.preprocessor.util.Util.*

/**
 * XMI model generator
 * 
 */
class TestGenerator extends AbstractPlatformGenerator {
	
	// Provides extension methods, e.g. getfullyQualifiedName for EObjects 
	@Inject extension IQualifiedNameProvider nameProvider
	
	override doGenerate(IExtendedFileSystemAccess fsa) {
		
		for(view: dataContainer.view.viewElements) {
			fsa.generateFile(rootFolder + "/view.test", traverse(view))
		}
		val modelsCopy = processedInput.copyModel
		val xmiSet = new ResourceSetImpl()
		modelsCopy.resources.forEach[ res |
			var xmiResource = xmiSet.createResource(res.URI.trimSegments(1).appendSegment(res.URI.lastSegment.replace(".md2", ".xmi")))
			xmiResource.contents += res.contents.head
		]
		xmiSet.resources.forEach[ xmiRes |
			val tmpFile = File::createTempFile("resource", null)
			xmiRes.save(new FileOutputStream(tmpFile),null)
			val StringBuilder text = new StringBuilder();
    		val Scanner scanner = new Scanner(new FileInputStream(tmpFile), "UTF-8");
			try {
				while (scanner.hasNextLine()){
					text.append(scanner.nextLine() + System::getProperty("line.separator"));
				}
			} finally{
				scanner.close();
			}
			val relativeURI = rootFolder + "/" + xmiRes.URI.segment(xmiRes.URI.segmentCount-2) + "/" + xmiRes.URI.lastSegment
			fsa.generateFile(relativeURI, text)
		]	
	}	
	
	// Find all elements by using recursion
	def String traverse (EObject obj) {
		var String output = switch (obj) {
			TextInput: "["+obj.eClass.name+ "] " + obj.fullyQualifiedName + " (label: "+obj.labelText+")\n"
			OptionInput: "["+obj.eClass.name+ "] " + obj.fullyQualifiedName + " (label: "+obj.labelText+")\n"
			ContainerElement: "["+obj.eClass.name+ "] " + obj.fullyQualifiedName + "\n"
			ContentElement: "["+obj.eClass.name+ "] " + obj.name + "\n"
			default: ""
		}
		val objs = obj.eContents.sort(
			[EObject obj1, EObject obj2 |
				if (obj1 instanceof ContainerElement && obj2 instanceof ContentElement) return 1
				else if (obj2 instanceof ContainerElement && obj1 instanceof ContentElement) return -1
				else return 0
			])
		for (child : objs) {
			output = output + traverse(child);
		}
		output
	}
	
	override getPlatformPrefix() {
		"test"
	}
	
}

