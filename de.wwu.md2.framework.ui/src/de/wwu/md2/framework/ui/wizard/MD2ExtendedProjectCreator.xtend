package de.wwu.md2.framework.ui.wizard

import com.google.inject.Inject
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.IResource
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IProgressMonitor

class MD2ExtendedProjectCreator extends MD2ProjectCreator {
	
	@Inject
	private MD2NewProjectWizardInitialContents initialContents;
	
	override enhanceProject(IProject project, IProgressMonitor monitor) throws CoreException {
		val access = getFileSystemAccess(project, monitor);
		// Pass project info to access meta data in initialContents
		initialContents.projectInfo = projectInfo
		initialContents.generateInitialContents(access);
		project.refreshLocal(IResource.DEPTH_INFINITE, monitor);
	}
}