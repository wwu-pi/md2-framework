package de.wwu.md2.framework.ui.wizard;

import java.util.Collections;
import java.util.List;

import org.eclipse.jdt.core.JavaCore;
import org.eclipse.xtext.ui.XtextProjectHelper;
import org.eclipse.xtext.ui.util.PluginProjectFactory;
import org.eclipse.xtext.ui.util.ProjectFactory;

import com.google.common.collect.ImmutableList;
import com.google.inject.Inject;
import com.google.inject.Provider;

public class MD2ExtendedProjectCreator extends MD2ProjectCreator {
	
	@Inject
	private Provider<MD2PluginProjectFactory> projectFactoryProvider;
	
	// Override SRC_FOLDER_LIST of super class
	protected final List<String> SRC_FOLDER_LIST = ImmutableList.of(SRC_ROOT);
	
	// Define list of none-source folders to be created
	protected static final String GEN_ROOT = "src-gen";
	protected static final String RESOURCES_ROOT = "resources";
	protected static final String RESOURCES_IMAGES = "resources/images";
	protected final List<String> NONE_SRC_FOLDER_LIST = ImmutableList.of(GEN_ROOT, RESOURCES_ROOT, RESOURCES_IMAGES);
	
	@Override
	protected List<String> getRequiredBundles() {
		// do not import default bundles defined in abstract class
		return Collections.emptyList();
	}
	
	@Override
	protected List<String> getImportedPackages() {
		// do not import default bundles defined in abstract class
		return Collections.emptyList();
	}
	
	@Override
	protected PluginProjectFactory createProjectFactory() {
		return projectFactoryProvider.get();
	}
	
	@Override
	protected List<String> getAllFolders() {
        return SRC_FOLDER_LIST;
    }
	
	@Override
	protected ProjectFactory configureProjectFactory(ProjectFactory factory) {
		MD2PluginProjectFactory result = (MD2PluginProjectFactory) super.configureProjectFactory(factory);
		return result.addNoneSourceFolders(NONE_SRC_FOLDER_LIST);
	}
	
	@Override
	protected String[] getProjectNatures() {
		return new String[] {
			JavaCore.NATURE_ID,
			XtextProjectHelper.NATURE_ID
		};
	}
	
	@Override
	protected String[] getBuilders() {
		return new String[]{
			JavaCore.BUILDER_ID,
			XtextProjectHelper.BUILDER_ID
		};
	}
	
}
