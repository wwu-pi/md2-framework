package de.wwu.md2.framework.generator.ios.misc

import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.generator.ios.Settings
import de.wwu.md2.framework.generator.ios.util.IOSGeneratorUtil

class ProjectBundle {
	
	def static generateProjectFile(DataContainer container) '''
	
	'''
	
	def static generateXcschememanagement(DataContainer container) '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>SchemeUserState</key>
	<dict>
		<key>«Settings.APP_NAME».xcscheme</key>
		<dict>
			<key>orderHint</key>
			<integer>0</integer>
		</dict>
	</dict>
	<key>SuppressBuildableAutocreation</key>
	<dict>
		<key>«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_APP)»</key>
		<dict>
			<key>primary</key>
			<true/>
		</dict>
		<key>«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_TEST)»</key>
		<dict>
			<key>primary</key>
			<true/>
		</dict>
	</dict>
</dict>
</plist>
	'''
	
	def static generateXcscheme(DataContainer container) '''
<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "0630"
   version = "1.3">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_APP)»"
               BuildableName = "«Settings.APP_NAME».app"
               BlueprintName = "«Settings.APP_NAME»"
               ReferencedContainer = "container:«Settings.APP_NAME».xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "NO"
            buildForArchiving = "NO"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_TEST)»"
               BuildableName = "«Settings.XCODE_TARGET_TEST».xctest"
               BlueprintName = "«Settings.XCODE_TARGET_TEST»"
               ReferencedContainer = "container:«Settings.APP_NAME».xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      shouldUseLaunchSchemeArgsEnv = "YES"
      buildConfiguration = "Debug">
      <Testables>
         <TestableReference
            skipped = "NO">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_TEST)»"
               BuildableName = "«Settings.XCODE_TARGET_TEST».xctest"
               BlueprintName = "«Settings.XCODE_TARGET_TEST»"
               ReferencedContainer = "container:«Settings.APP_NAME».xcodeproj">
            </BuildableReference>
         </TestableReference>
      </Testables>
      <MacroExpansion>
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_APP)»"
            BuildableName = "«Settings.APP_NAME».app"
            BlueprintName = "«Settings.APP_NAME»"
            ReferencedContainer = "container:«Settings.APP_NAME».xcodeproj">
         </BuildableReference>
      </MacroExpansion>
   </TestAction>
   <LaunchAction
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      buildConfiguration = "Debug"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_APP)»"
            BuildableName = "«Settings.APP_NAME».app"
            BlueprintName = "«Settings.APP_NAME»"
            ReferencedContainer = "container:«Settings.APP_NAME».xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
      <AdditionalOptions>
      </AdditionalOptions>
   </LaunchAction>
   <ProfileAction
      shouldUseLaunchSchemeArgsEnv = "YES"
      savedToolIdentifier = ""
      useCustomWorkingDirectory = "NO"
      buildConfiguration = "Release"
      debugDocumentVersioning = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_APP)»"
            BuildableName = "«Settings.APP_NAME».app"
            BlueprintName = "«Settings.APP_NAME»"
            ReferencedContainer = "container:«Settings.APP_NAME».xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </ProfileAction>
   <AnalyzeAction
      buildConfiguration = "Debug">
   </AnalyzeAction>
   <ArchiveAction
      buildConfiguration = "Release"
      revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>
'''
	
	def static generateWorkspaceContent(DataContainer container) '''
<?xml version="1.0" encoding="UTF-8"?>
<Workspace
   version = "1.0">
   <FileRef
      location = "self:«Settings.APP_NAME».xcodeproj">
   </FileRef>
</Workspace>
'''
		
}