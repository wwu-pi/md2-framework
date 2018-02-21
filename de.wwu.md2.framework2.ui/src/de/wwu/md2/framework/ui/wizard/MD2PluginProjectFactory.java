package de.wwu.md2.framework.ui.wizard;

import java.util.List;

import org.eclipse.core.resources.IFolder;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.SubMonitor;
import org.eclipse.jdt.core.IClasspathEntry;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.xtext.ui.util.PluginProjectFactory;

import com.google.common.collect.Lists;

/**
 * <p>This plug-in factory extends the default behavior of PluginProjectFactory.</p>
 * 
 * <p>Currently it mainly suppresses the creation of some default project files and
 * classpath entries that are not needed in the context of MD2 projects.</p>
 */
public class MD2PluginProjectFactory extends PluginProjectFactory {
	
	protected List<String> noneSourceFolders;
	
	@Override
	protected void createBuildProperties(IProject project, IProgressMonitor progressMonitor) {
		// do not create build.properties file
	}
	
	@Override
	protected void createManifest(IProject project, IProgressMonitor progressMonitor) throws CoreException {
		// do not create Manifest file
	}
	
	@Override
	protected void addMoreClasspathEntriesTo(List<IClasspathEntry> classpathEntries) {
		// do not add any more classpath entries
	}
	
	/**
	 * Create all source and none-source folders for the new project.
	 */
	@Override
	protected void createFolders(IProject project, SubMonitor subMonitor, Shell shell) throws CoreException {
		// build source folders
		super.createFolders(project, subMonitor, shell);
		
		// build none-source folders
		if (noneSourceFolders != null) {
			for (final String folderName : noneSourceFolders) {
				final IFolder folder = project.getFolder(folderName);
				if (!folder.exists()) {
					folder.create(false, true, subMonitor.newChild(1));
				}
			}
		}
	}
	
	/**
	 * Add none-source folders that should be created in the new project.
	 * 
	 * @param folders List of none source-folders to be created.
	 * @return The current instance of the MD2PluginProjectFactory with the folders added.
	 */
	public MD2PluginProjectFactory addNoneSourceFolders(List<String> folders) {
		if (this.noneSourceFolders == null)
			this.noneSourceFolders = Lists.newArrayList();
		this.noneSourceFolders.addAll(folders);
		return this;
	}
}
