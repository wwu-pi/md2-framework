package de.wwu.md2.framework.generator.backend

import de.wwu.md2.framework.generator.AbstractPlatformGenerator
import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.ModelElement
import de.wwu.md2.framework.mD2.ReferencedModelType

import static de.wwu.md2.framework.generator.backend.BeanClass.*
import static de.wwu.md2.framework.generator.backend.CommonClasses.*
import static de.wwu.md2.framework.generator.backend.DatatypeClasses.*
import static de.wwu.md2.framework.generator.backend.DotClasspath.*
import static de.wwu.md2.framework.generator.backend.DotProjectFile.*
import static de.wwu.md2.framework.generator.backend.EnumAndEntityClass.*
import static de.wwu.md2.framework.generator.backend.PersistenceXml.*
import static de.wwu.md2.framework.generator.backend.ProjectSettings.*
import static de.wwu.md2.framework.generator.backend.ValidationResult.*
import static de.wwu.md2.framework.generator.backend.WebContentFiles.*
import static de.wwu.md2.framework.generator.backend.WebServiceClass.*
import static de.wwu.md2.framework.util.MD2Util.*

/**
 * backend generator
 */
class BackendGenerator extends AbstractPlatformGenerator {
	
	override doGenerate(IExtendedFileSystemAccess fsa) {
		
		/////////////////////////////////////////
		// Feasibility check
		/////////////////////////////////////////
		
		// Check whether a main block has been defined. Otherwise do not run the generator.
		if(dataContainer.main == null) {
			System::out.println("Backend: No main block found. Quit gracefully.")
			return
		}
		
		
		/////////////////////////////////////////
		// Generation work flow
		/////////////////////////////////////////
		
		// Clean backend folder
		fsa.deleteDirectory(basePackageName)
		
		// Generate models, web services and beans
		dataContainer.models.forEach [model |
			model.modelElements.filter(typeof(ModelElement)).forEach[modelElement |
				fsa.generateFile(basePackageName + "/src/" + basePackageName.replace('.', '/') + "/models/"
					+ modelElement.name.toFirstUpper + ".java", createModel(basePackageName, modelElement))
				
				if(modelElement instanceof Entity) {
					fsa.generateFile(basePackageName + "/src/" + basePackageName.replace('.', '/') + "/ws/"
						+ modelElement.name.toFirstUpper + "WS.java", createEntityWS(basePackageName, modelElement as Entity))
					fsa.generateFile(basePackageName + "/src/" + basePackageName.replace('.', '/') + "/beans/"
						+ modelElement.name.toFirstUpper + "Bean.java", createEntityBean(basePackageName, modelElement as Entity))
				}
			]
		]
		
		// Generate datatype wrapper
		fsa.generateFile(basePackageName + "/src/" + basePackageName.replace('.', '/') + "/datatypes/BooleanWrapper.java", createBooleanWrapper(basePackageName))
		fsa.generateFile(basePackageName + "/src/" + basePackageName.replace('.', '/') + "/datatypes/DateWrapper.java", createDateWrapper(basePackageName))
		fsa.generateFile(basePackageName + "/src/" + basePackageName.replace('.', '/') + "/datatypes/DecimalWrapper.java", createDecimalWrapper(basePackageName))
		fsa.generateFile(basePackageName + "/src/" + basePackageName.replace('.', '/') + "/datatypes/IntegerWrapper.java", createIntegerWrapper(basePackageName))
		fsa.generateFile(basePackageName + "/src/" + basePackageName.replace('.', '/') + "/datatypes/InternalIdWrapper.java", createInternalIdWrapper(basePackageName))
		fsa.generateFile(basePackageName + "/src/" + basePackageName.replace('.', '/') + "/datatypes/IsValidWrapper.java", createIsValidWrapper(basePackageName))
		fsa.generateFile(basePackageName + "/src/" + basePackageName.replace('.', '/') + "/datatypes/StringWrapper.java", createStringWrapper(basePackageName))
		fsa.generateFile(basePackageName + "/src/" + basePackageName.replace('.', '/') + "/datatypes/TimestampWrapper.java", createTimestampWrapper(basePackageName))
		fsa.generateFile(basePackageName + "/src/" + basePackageName.replace('.', '/') + "/datatypes/TimeWrapper.java", createTimeWrapper(basePackageName))
		
		// Generate validation and model version web services
		val affectedEntities = <ModelElement>newHashSet
		affectedEntities.addAll(dataContainer.remoteValidators.filter(v | v.contentProvider != null && v.contentProvider.contentProvider.type instanceof ReferencedModelType)
			.map(v | (v.contentProvider.contentProvider.type as ReferencedModelType).entity).filter(typeof(Entity)))
		
		fsa.generateFile(basePackageName + "/src/" + basePackageName.replace('.', '/') + "/ws/VersionNegotiationWS.java", createVersionNegotiationWS(basePackageName))
		fsa.generateFile(basePackageName + "/src/" + basePackageName.replace('.', '/') + "/datatypes/ValidationResult.java", createValidationResult(basePackageName))
		fsa.generateFile(basePackageName + "/src/" + basePackageName.replace('.', '/') + "/datatypes/ValidationError.java", createValidationError(basePackageName))
		
		if(!dataContainer.remoteValidators.empty) {
			fsa.generateFile(basePackageName + "/src/" + basePackageName.replace('.', '/') + "/ws/RemoteValidationWS.java",
				createRemoteValidationWS(basePackageName, affectedEntities, dataContainer.remoteValidators))
			fsa.generateFile(basePackageName + "/src/" + basePackageName.replace('.', '/') + "/beans/RemoteValidationBean.java",
				createRemoteValidationBean(basePackageName, affectedEntities, dataContainer.remoteValidators))
		}
		
		// Generate common backend files
		fsa.generateFile(basePackageName + "/src/" + basePackageName.replace('.', '/') + "/Utils.java", createUtils(basePackageName))
		fsa.generateFile(basePackageName + "/src/" + basePackageName.replace('.', '/') + "/Config.java", createConfig(basePackageName, dataContainer))
		
		// Generate persistence.xml
		fsa.generateFile(basePackageName + "/src/META-INF/persistence.xml", createPersistenceXml(basePackageName))
		
		// Generate .settings folder
		// TODO: check necessity
		fsa.generateFile(basePackageName + "/.settings/.jsdtscope", jsdtscope)
		fsa.generateFile(basePackageName + "/.settings/org.eclipse.jdt.core.prefs", orgEclipseJdtCorePrefs)
		fsa.generateFile(basePackageName + "/.settings/org.eclipse.jpt.core.prefs", orgEclipseJptCorePrefs)
		fsa.generateFile(basePackageName + "/.settings/org.eclipse.wst.common.component", orgEclipseWstCommonComponent(basePackageName))
		fsa.generateFile(basePackageName + "/.settings/org.eclipse.wst.common.project.facet.core.prefs.xml", orgEclipseWstCommonProjectFacetCorePrefs)
		fsa.generateFile(basePackageName + "/.settings/org.eclipse.wst.common.project.facet.core.xml", orgEclipseWstCommonProjectFacetCore)
		fsa.generateFile(basePackageName + "/.settings/org.eclipse.wst.jsdt.ui.superType.container", orgEclipseWstJsdtUiSuperTypeContainer)
		fsa.generateFile(basePackageName + "/.settings/org.eclipse.wst.jsdt.ui.superType.name", orgEclipseWstJsdtUiSuperTypeName)
		
		// Generate .classpath and .project files
		fsa.generateFile(basePackageName + "/.classpath", createClasspath)
		fsa.generateFile(basePackageName + "/.project", createProjectFile(basePackageName))
		
		// Generate WebContent folder
		fsa.generateFile(basePackageName + "/WebContent/index.jsp", indexJsp)
		fsa.generateFile(basePackageName + "/WebContent/META-INF/MANIFEST.MF", manifest)
		fsa.generateFile(basePackageName + "/WebContent/WEB-INF/sun-web.xml", sunWebXml(basePackageName)) // TODO: necessary?
		fsa.generateFile(basePackageName + "/WebContent/WEB-INF/web.xml", webXml(basePackageName))
		
		// Copy static jar libs
		fsa.generateFileFromInputStream(getSystemResource("/backend/guava-13.0.jar"), basePackageName + "/WebContent/WEB-INF/lib/guava-13.0.jar")
		fsa.generateFileFromInputStream(getSystemResource("/backend/jackson-core-asl-1.9.2.jar"), basePackageName + "/WebContent/WEB-INF/lib/jackson-core-asl-1.9.2.jar")
		fsa.generateFileFromInputStream(getSystemResource("/backend/jackson-jaxrs-1.9.2.jar"), basePackageName + "/WebContent/WEB-INF/lib/jackson-jaxrs-1.9.2.jar")
		fsa.generateFileFromInputStream(getSystemResource("/backend/jackson-mapper-asl-1.9.2.jar"), basePackageName + "/WebContent/WEB-INF/lib/jackson-mapper-asl-1.9.2.jar")
		fsa.generateFileFromInputStream(getSystemResource("/backend/jackson-xc-1.9.2.jar"), basePackageName + "/WebContent/WEB-INF/lib/jackson-xc-1.9.2.jar")
		fsa.generateFileFromInputStream(getSystemResource("/backend/jersey-bundle-1.18.1.jar"), basePackageName + "/WebContent/WEB-INF/lib/jersey-bundle-1.18.1.jar")
		
	}
	
	override getPlatformPrefix() {
		"backend"
	}
}
