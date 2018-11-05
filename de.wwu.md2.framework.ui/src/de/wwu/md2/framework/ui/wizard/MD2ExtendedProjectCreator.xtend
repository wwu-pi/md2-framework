package de.wwu.md2.framework.ui.wizard

import com.google.common.collect.ImmutableList
import com.google.inject.Inject
import java.util.ArrayList
import java.util.List
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.IResource
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IProgressMonitor

class MD2ExtendedProjectCreator extends MD2ProjectCreator {
	
	@Inject 
	MD2NewProjectWizardInitialContents initialContents;
	
	override enhanceProject(IProject project, IProgressMonitor monitor) throws CoreException {
		val access = getFileSystemAccess(project, monitor);
		// Pass project info to access meta data in initialContents
		initialContents.projectInfo = projectInfo
		initialContents.generateInitialContents(access);
		project.refreshLocal(IResource.DEPTH_INFINITE, monitor);
	}
	
	override protected List<String> getAllFolders() {
		// Do not add src-gen to src-classpath
		return ImmutableList.of(getModelFolderName());
	}
	
	override protected String[] getProjectNatures() {
		var natures = new ArrayList<String>();
		for(String nature : super.getProjectNatures()) {
			natures.add(nature);
		}
		return natures.toArray(#[] as String[]);
	}
}