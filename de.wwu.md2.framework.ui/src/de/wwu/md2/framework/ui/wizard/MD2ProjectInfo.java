package de.wwu.md2.framework.ui.wizard;

import org.eclipse.core.runtime.IPath;
import org.eclipse.xtext.ui.wizard.DefaultProjectInfo;
import org.eclipse.xtext.ui.wizard.IExtendedProjectInfo;

/**
 * Provide information to be used in the template file in this class.
 */
public class MD2ProjectInfo extends DefaultProjectInfo implements IExtendedProjectInfo {

	protected IPath locationPath;
	
	@Override
	public IPath getLocationPath() {
		return locationPath;
	}

	@Override
	public void setLocationPath(IPath locationPath) {
		this.locationPath = locationPath;
	}
}
