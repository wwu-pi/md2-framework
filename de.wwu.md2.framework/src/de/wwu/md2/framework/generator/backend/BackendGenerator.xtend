package de.wwu.md2.framework.generator.backend

import de.wwu.md2.framework.generator.AbstractPlatformGenerator
import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.ModelElement
import de.wwu.md2.framework.mD2.ReferencedModelType

import static de.wwu.md2.framework.generator.backend.BeanClass.*
import static de.wwu.md2.framework.generator.backend.CommonClasses.*
import static de.wwu.md2.framework.generator.backend.DatatypeClasses.*
import static de.wwu.md2.framework.generator.backend.DotProjectFile.*
import static de.wwu.md2.framework.generator.backend.EnumAndEntityClass.*
import static de.wwu.md2.framework.generator.backend.FileUpload.*
import static de.wwu.md2.framework.generator.backend.ExternalWebServiceClass.*
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
		// Generation work flow
		/////////////////////////////////////////
		
		// Generate models, web services and beans
		dataContainer.model.modelElements.filter(typeof(ModelElement)). // remove auto-generated local entities starting with "__"
			filter[!it.name.startsWith("__")].forEach[modelElement |
			fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/entities/models/"
				+ modelElement.name.toFirstUpper + ".java", createModel(rootFolder, modelElement))
			
			val isUsedInRemoteContentProvider = dataContainer.contentProviders.exists[ c |
				c.type instanceof ReferencedModelType
				&& !c.local
				&& (c.type as ReferencedModelType).entity.identityEquals(modelElement)
			]
			
			// web services and beans for an entity are only generated if they are used in any remote content provider
			if(modelElement instanceof Entity && isUsedInRemoteContentProvider) {
				fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/ws/"
					+ modelElement.name.toFirstUpper + "WS.java", createEntityWS(rootFolder, modelElement as Entity))
				fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/beans/"
					+ modelElement.name.toFirstUpper + "Bean.java", createEntityBean(rootFolder, modelElement as Entity))
			}
		]
		
		// Generate datatype wrapper
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/datatypes/BooleanWrapper.java", createBooleanWrapper(basePackageName))
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/datatypes/DateWrapper.java", createDateWrapper(basePackageName))
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/datatypes/DecimalWrapper.java", createDecimalWrapper(basePackageName))
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/datatypes/IntegerWrapper.java", createIntegerWrapper(basePackageName))
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/datatypes/InternalIdWrapper.java", createInternalIdWrapper(basePackageName))
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/datatypes/IsValidWrapper.java", createIsValidWrapper(basePackageName))
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/datatypes/StringWrapper.java", createStringWrapper(basePackageName))
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/datatypes/TimestampWrapper.java", createTimestampWrapper(basePackageName))
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/datatypes/TimeWrapper.java", createTimeWrapper(basePackageName))
		
		// Generate validation and model version web services
		val affectedEntities = <ModelElement>newHashSet
		affectedEntities.addAll(dataContainer.remoteValidators.filter(v | v.contentProvider != null && v.contentProvider.contentProvider.type instanceof ReferencedModelType)
			.map(v | (v.contentProvider.contentProvider.type as ReferencedModelType).entity).filter(typeof(Entity)))
		
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/ws/VersionNegotiationWS.java", createVersionNegotiationWS(basePackageName))
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/datatypes/ValidationResult.java", createValidationResult(basePackageName))
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/datatypes/ValidationError.java", createValidationError(basePackageName))
		
		if(!dataContainer.remoteValidators.empty) {
			fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/ws/RemoteValidationWS.java",
				createRemoteValidationWS(rootFolder, affectedEntities, dataContainer.remoteValidators))
			fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/beans/RemoteValidationBean.java",
				createRemoteValidationBean(rootFolder, affectedEntities, dataContainer.remoteValidators))
		}
		
		// Generate workflow managing files
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/beans/WorkflowStateBean.java", createWorkflowStateBean(rootFolder))
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/entities/WorkflowState.java", createWorkflowState(rootFolder))
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/ws/WorkflowStateWS.java", createWorkflowStateWS(rootFolder))
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/ws/EventHandlerWS.java", createEventHandlerWS(rootFolder))
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/ws/FileUploadWS.java", createFileUploadWS(rootFolder))
		
		// Generate additional servlet
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/filedownload/DownloadServlet.java", createDownloadServlet(rootFolder))
		
		// External Werbservices
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/entities/RequestDTO.java", createRequestDTO(rootFolder))
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/ws/CallExternalWebServiceWS.java", createCallExternalWSProxy(basePackageName))
		
		
		// Gemerate external webService files
		dataContainer.workflowElements.filter[it.invoke.size>0].forEach[wfe|
			fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/ws/external/" + wfe.name.toFirstUpper + "ExternalWS.java", createExternalWorkflowElementWS(basePackageName, wfe, dataContainer.main.workflowManager))
		]
		// Generate common backend files
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/Utils.java", createUtils(basePackageName))
		fsa.generateFile(rootFolder + "/src/" + rootFolder.replace('.', '/') + "/Config.java", createConfig(basePackageName, dataContainer))
		
		// Generate persistence.xml
		fsa.generateFile(rootFolder + "/src/META-INF/persistence.xml", createPersistenceXml(basePackageName))
		
		// Generate .settings folder
		// TODO: check necessity
		fsa.generateFile(rootFolder + "/.settings/.jsdtscope", jsdtscope)
		fsa.generateFile(rootFolder + "/.settings/org.eclipse.jdt.core.prefs", orgEclipseJdtCorePrefs)
		fsa.generateFile(rootFolder + "/.settings/org.eclipse.jpt.core.prefs", orgEclipseJptCorePrefs)
		fsa.generateFile(rootFolder + "/.settings/org.eclipse.wst.common.component", orgEclipseWstCommonComponent(basePackageName))
		fsa.generateFile(rootFolder + "/.settings/org.eclipse.wst.common.project.facet.core.prefs.xml", orgEclipseWstCommonProjectFacetCorePrefs)
		fsa.generateFile(rootFolder + "/.settings/org.eclipse.wst.common.project.facet.core.xml", orgEclipseWstCommonProjectFacetCore)
		fsa.generateFile(rootFolder + "/.settings/org.eclipse.wst.jsdt.ui.superType.container", orgEclipseWstJsdtUiSuperTypeContainer)
		fsa.generateFile(rootFolder + "/.settings/org.eclipse.wst.jsdt.ui.superType.name", orgEclipseWstJsdtUiSuperTypeName)
		
		// Generate .classpath and .project files
		fsa.generateFileFromInputStream(getSystemResource("/backend/classpath.txt"), rootFolder + "/.classpath")
		fsa.generateFile(rootFolder + "/.project", createProjectFile(basePackageName))
		
		// Generate WebContent folder
		fsa.generateFile(rootFolder + "/WebContent/index.jsp", indexJsp)
		fsa.generateFile(rootFolder + "/WebContent/META-INF/MANIFEST.MF", manifest)
		fsa.generateFile(rootFolder + "/WebContent/WEB-INF/sun-web.xml", sunWebXml(basePackageName)) // TODO: necessary?
		fsa.generateFile(rootFolder + "/WebContent/WEB-INF/web.xml", webXml(basePackageName))
		
		// Copy static jar libs
		fsa.generateFileFromInputStream(getSystemResource("/backend/json-simple-1.1.1.jar"), rootFolder + "/WebContent/WEB-INF/lib/json-simple-1.1.1.jar")
		fsa.generateFileFromInputStream(getSystemResource("/backend/guava-13.0.jar"), rootFolder + "/WebContent/WEB-INF/lib/guava-13.0.jar")
		fsa.generateFileFromInputStream(getSystemResource("/backend/jackson-core-asl-1.9.2.jar"), rootFolder + "/WebContent/WEB-INF/lib/jackson-core-asl-1.9.2.jar")
		fsa.generateFileFromInputStream(getSystemResource("/backend/jackson-jaxrs-1.9.2.jar"), rootFolder + "/WebContent/WEB-INF/lib/jackson-jaxrs-1.9.2.jar")
		fsa.generateFileFromInputStream(getSystemResource("/backend/jackson-mapper-asl-1.9.2.jar"), rootFolder + "/WebContent/WEB-INF/lib/jackson-mapper-asl-1.9.2.jar")
		fsa.generateFileFromInputStream(getSystemResource("/backend/jackson-xc-1.9.2.jar"), rootFolder + "/WebContent/WEB-INF/lib/jackson-xc-1.9.2.jar")
	}
	
	override getPlatformPrefix() {
		"backend"
	}
}
