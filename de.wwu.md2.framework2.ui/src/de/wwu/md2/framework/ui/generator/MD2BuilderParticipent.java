package de.wwu.md2.framework.ui.generator;

import static com.google.common.collect.Sets.newLinkedHashSet;

import java.util.List;
import java.util.Map;
import java.util.Set;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IMarker;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.OperationCanceledException;
import org.eclipse.core.runtime.SubMonitor;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.xtext.builder.BuilderParticipant;
import org.eclipse.xtext.builder.DerivedResourceMarkers;
import org.eclipse.xtext.builder.EclipseResourceFileSystemAccess2;
import org.eclipse.xtext.generator.OutputConfiguration;
import org.eclipse.xtext.resource.IContainer;
import org.eclipse.xtext.resource.IContainer.Manager;
import org.eclipse.xtext.resource.IResourceDescription;
import org.eclipse.xtext.resource.IResourceDescription.Delta;
import org.eclipse.xtext.resource.IResourceDescriptions;
import org.eclipse.xtext.resource.impl.ResourceDescriptionsProvider;

import com.google.inject.Inject;
import com.google.inject.Provider;

import de.wwu.md2.framework.generator.IPlatformGenerator;

/**
 * Builder Participant changes the way the generators get invoked
 */
public class MD2BuilderParticipent extends BuilderParticipant {
	
	@Inject
	ResourceDescriptionsProvider resourceDescriptionsProvider;
	
	@Inject
	Manager containerManager;
	
	@Inject
	Set<IPlatformGenerator> generators;
	
	@Inject
	private Provider<ExtendedEclipseResourceFileSystemAccess2> fileSystemAccessProvider;
	
	@Inject
	private DerivedResourceMarkers derivedResourceMarkers;
	
	/**
	 * This handleChangedContents method is capable to handle multiple generators and it passes the extended
	 * EclipseResourceFileSystemAccess2 to the generators. Furthermore, it ensures that only resources of the
	 * current container are passed to the generators to prevent conflicts in case that several independent projects
	 * are loaded at the same time.
	 */
	@Override
	protected void handleChangedContents(Delta delta, IBuildContext context, EclipseResourceFileSystemAccess2 fileSystemAccess) throws CoreException {
		
		if (!getResourceServiceProvider().canHandle(delta.getUri())) {
			return;
		}
		
		// TODO: we will run out of memory here if the number of deltas is large enough
		Resource resource = context.getResourceSet().getResource(delta.getUri(), true);
		if (shouldGenerate(resource, context)) {
			IResourceDescriptions index = resourceDescriptionsProvider.createResourceDescriptions();
			IResourceDescription resDesc = index.getResourceDescription(resource.getURI());
			List<IContainer> visibleContainers = containerManager.getVisibleContainers(resDesc, index);
			
			// get all resources of current container
			ResourceSet resourceSet = new ResourceSetImpl();
			for (IContainer c : visibleContainers) {
				for (IResourceDescription rd : c.getResourceDescriptions()) {
					resourceSet.getResource(rd.getURI(), true);
				}
			}
			
			// run generator for each supported platform
			for (IPlatformGenerator generator : generators) {
				generator.doGenerate(resourceSet, (ExtendedEclipseResourceFileSystemAccess2)fileSystemAccess);
			}
		}
	}
	
	/**
	 * The implementation of this method has almost completely been copied from super class -- EclipseResourceFileSystemAccess2
	 * has been replaced by ExtendedEclipseResourceFileSystemAccess2. This was necessary, because the fileSystemAccessProvider
	 * has been injected as a private attribute in the superclass so that it was not possible to overwrite it.
	 */
	@SuppressWarnings("deprecation")
	@Override
	public void build(final IBuildContext context, IProgressMonitor monitor) throws CoreException {
		if (!isEnabled(context)) {
			return;
		}
		final int numberOfDeltas = context.getDeltas().size();
		
		// monitor handling
		if (monitor.isCanceled())
			throw new OperationCanceledException();
		SubMonitor subMonitor = SubMonitor.convert(monitor, numberOfDeltas + 3);
		
		ExtendedEclipseResourceFileSystemAccess2 access = fileSystemAccessProvider.get();
		final IProject builtProject = context.getBuiltProject();
		access.setProject(builtProject);
		final Map<String, OutputConfiguration> outputConfigurations = getOutputConfigurations(context);
		refreshOutputFolders(context, outputConfigurations, subMonitor.newChild(1));
		access.setOutputConfigurations(outputConfigurations);
		if (context.getBuildType() == BuildType.CLEAN || context.getBuildType() == BuildType.RECOVERY) {
			SubMonitor cleanMonitor = SubMonitor.convert(subMonitor.newChild(1), outputConfigurations.size());
			for (OutputConfiguration config : outputConfigurations.values()) {
				cleanOutput(context, config, cleanMonitor.newChild(1));
			}
			if (context.getBuildType() == BuildType.CLEAN)
				return;
		}
		for (int i = 0 ; i < numberOfDeltas ; i++) {
			final IResourceDescription.Delta delta = context.getDeltas().get(i);
			
			// monitor handling
			if (subMonitor.isCanceled())
				throw new OperationCanceledException();
			subMonitor.subTask("Compiling "+delta.getUri().lastSegment()+" ("+i+" of "+numberOfDeltas+")");
			access.setMonitor(subMonitor.newChild(1));
			
			final String uri = delta.getUri().toString();
			final Set<IFile> derivedResources = newLinkedHashSet();
			for (OutputConfiguration config : outputConfigurations.values()) {
				if (config.isCleanUpDerivedResources()) {
					List<IFile> resources = derivedResourceMarkers.findDerivedResources(builtProject.getFolder(config.getOutputDirectory()), uri);
					derivedResources.addAll(resources);
				}
			}
			access.setPostProcessor(new EclipseResourceFileSystemAccess2.IFileCallback() {
				
				public boolean beforeFileDeletion(IFile file) {
					derivedResources.remove(file);
					context.needRebuild();
					return true;
				}
				
				public void afterFileUpdate(IFile file) {
					handleFileAccess(file);
				}

				public void afterFileCreation(IFile file) {
					handleFileAccess(file);
				}
				
				protected void handleFileAccess(IFile file) {
					try {
						derivedResources.remove(file);
						derivedResourceMarkers.installMarker(file, uri);
						context.needRebuild();
					} catch (CoreException e) {
						throw new RuntimeException(e);
					}
				}
				
			});
			if (delta.getNew() != null) {
				handleChangedContents(delta, context, access);
			}
			SubMonitor deleteMonitor = SubMonitor.convert(subMonitor.newChild(1), derivedResources.size());
			for (IFile iFile : derivedResources) {
				IMarker marker = derivedResourceMarkers.findDerivedResourceMarker(iFile, uri);
				if (marker != null)
					marker.delete();
				if (derivedResourceMarkers.findDerivedResourceMarkers(iFile).length == 0) {
					iFile.delete(IResource.KEEP_HISTORY, deleteMonitor.newChild(1));
					context.needRebuild();
				}
			}
		}
	}
}
