package de.wwu.md2.framework.generator.backend

class ProjectSettings {
	
	def static jsdtscope() '''
		<?xml version="1.0" encoding="UTF-8"?>
		<classpath>
			<classpathentry kind="src" path="WebContent"/>
			<classpathentry kind="con" path="org.eclipse.wst.jsdt.launching.JRE_CONTAINER"/>
			<classpathentry kind="con" path="org.eclipse.wst.jsdt.launching.WebProject">
				<attributes>
					<attribute name="hide" value="true"/>
				</attributes>
			</classpathentry>
			<classpathentry kind="con" path="org.eclipse.wst.jsdt.launching.baseBrowserLibrary"/>
			<classpathentry kind="output" path=""/>
		</classpath>
	'''
	
	def static orgEclipseJdtCorePrefs() '''
		eclipse.preferences.version=1
		org.eclipse.jdt.core.compiler.codegen.inlineJsrBytecode=enabled
		org.eclipse.jdt.core.compiler.codegen.targetPlatform=1.6
		org.eclipse.jdt.core.compiler.codegen.unusedLocal=preserve
		org.eclipse.jdt.core.compiler.compliance=1.6
		org.eclipse.jdt.core.compiler.debug.lineNumber=generate
		org.eclipse.jdt.core.compiler.debug.localVariable=generate
		org.eclipse.jdt.core.compiler.debug.sourceFile=generate
		org.eclipse.jdt.core.compiler.problem.assertIdentifier=error
		org.eclipse.jdt.core.compiler.problem.enumIdentifier=error
		org.eclipse.jdt.core.compiler.source=1.6
	'''
	
	def static orgEclipseJptCorePrefs() '''
		eclipse.preferences.version=1
		org.eclipse.jpt.core.platform=generic2_0
		org.eclipse.jpt.jpa.core.discoverAnnotatedClasses=true
	'''
	
	def static orgEclipseWstCommonComponent(String basePackageName) '''
		<?xml version="1.0" encoding="UTF-8"?>
		<project-modules id="moduleCoreId" project-version="1.5.0">
		    <wb-module deploy-name="«basePackageName»">
		        <wb-resource deploy-path="/" source-path="/WebContent" tag="defaultRootSource"/>
		        <wb-resource deploy-path="/WEB-INF/classes" source-path="/src"/>
		        <property name="context-root" value="«basePackageName»"/>
		        <property name="java-output-path" value="/«basePackageName»/build/classes"/>
		    </wb-module>
		</project-modules>
	'''
	
	def static orgEclipseWstCommonProjectFacetCorePrefs() '''
		<root>
		  <facet id="jpt.jpa">
		    <node name="libprov">
		      <attribute name="provider-id" value="jpa-user-library-provider"/>
		    </node>
		  </facet>
		</root>
	'''
	
	def static orgEclipseWstCommonProjectFacetCore() '''
		<?xml version="1.0" encoding="UTF-8"?>
		<faceted-project>
		  <runtime name="GlassFish 4.0"/>
		  <fixed facet="java"/>
		  <fixed facet="jst.web"/>
		  <fixed facet="wst.jsdt.web"/>
		  <installed facet="jst.web" version="3.0"/>
		  <installed facet="sun.facet" version="9"/>
		  <installed facet="wst.jsdt.web" version="1.0"/>
		  <installed facet="jpt.jpa" version="2.0"/>
		  <installed facet="java" version="1.6"/>
		</faceted-project>
	'''
	
	def static orgEclipseWstJsdtUiSuperTypeContainer() '''
		org.eclipse.wst.jsdt.launching.baseBrowserLibrary
	'''
	
	def static orgEclipseWstJsdtUiSuperTypeName() '''
		Window
	'''
	
}