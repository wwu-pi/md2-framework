package de.wwu.md2.framework.generator.backend

class DotClasspath {
	
	def static createClasspath() '''
		<?xml version="1.0" encoding="UTF-8"?>
		<classpath>
			<classpathentry kind="src" path="src"/>
			<classpathentry kind="con" path="org.eclipse.jst.server.core.container/com.sun.enterprise.jst.server.runtimeTarget/GlassFish 3.1.2">
				<attributes>
					<attribute name="owner.project.facets" value="jst.web"/>
				</attributes>
			</classpathentry>
			<classpathentry kind="con" path="org.eclipse.jst.j2ee.internal.web.container"/>
			<classpathentry kind="con" path="org.eclipse.jst.j2ee.internal.module.container"/>
			<classpathentry kind="con" path="org.eclipse.datatools.connectivity.jdt.DRIVERLIBRARY/GlassFishSampleDB"/>
			<classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-1.6">
				<attributes>
					<attribute name="owner.project.facets" value="java"/>
				</attributes>
			</classpathentry>
			<classpathentry kind="con" path="org.eclipse.jdt.USER_LIBRARY/EclipseLink 2.3.2 - Indigo">
				<attributes>
					<attribute name="org.eclipse.jst.component.dependency" value="/WEB-INF/lib"/>
					<attribute name="owner.project.facets" value="jpt.jpa"/>
				</attributes>
			</classpathentry>
			<classpathentry kind="output" path="build/classes"/>
		</classpath>
	'''
	
}