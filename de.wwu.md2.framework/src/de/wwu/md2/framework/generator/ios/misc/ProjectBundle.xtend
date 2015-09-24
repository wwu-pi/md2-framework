package de.wwu.md2.framework.generator.ios.misc

import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.generator.ios.Settings
import de.wwu.md2.framework.generator.ios.util.IOSGeneratorUtil
import de.wwu.md2.framework.mD2.App
import de.wwu.md2.framework.mD2.CustomAction

class ProjectBundle {
	
	def static generateXcschememanagement() '''
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
	
	def static generateXcscheme() '''
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
	
	def static generateWorkspaceContent() '''
<?xml version="1.0" encoding="UTF-8"?>
<Workspace
   version = "1.0">
   <FileRef
      location = "self:«Settings.APP_NAME».xcodeproj">
   </FileRef>
</Workspace>
'''

	def static generateProjectFile(DataContainer container, App app) '''
// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 46;
	objects = {

/* Begin PBXBuildFile section */
		«FOR entity : container.entities»«val entityName = Settings.PREFIX_ENTITY + entity.name.toFirstUpper»
		«IOSGeneratorUtil.getUuid(entityName)» /* «entityName» in Sources */ = {isa = PBXBuildFile; fileRef = «IOSGeneratorUtil.getUuid(entityName + ".swift")» /* «entityName».swift */; };
		«ENDFOR»
		«FOR e : container.enums»«val enumName = Settings.PREFIX_ENUM + e.name.toFirstUpper»
		«IOSGeneratorUtil.getUuid(enumName)» /* «enumName» in Sources */ = {isa = PBXBuildFile; fileRef = «IOSGeneratorUtil.getUuid(enumName + ".swift")» /* «enumName».swift */; };
		«ENDFOR»
		«FOR cp : container.contentProviders»«val cpName = Settings.PREFIX_CONTENT_PROVIDER + cp.name.toFirstUpper»
		«IOSGeneratorUtil.getUuid(cpName)» /* «cpName» in Sources */ = {isa = PBXBuildFile; fileRef = «IOSGeneratorUtil.getUuid(cpName + ".swift")» /* «cpName».swift */; };
		«ENDFOR»
		«FOR ca : app.workflowElements.map[wfe | wfe.workflowElementReference.actions.filter(CustomAction)].flatten»«val caName = Settings.PREFIX_CUSTOM_ACTION + ca.name.toFirstUpper»
		«IOSGeneratorUtil.getUuid(caName)» /* «caName» in Sources */ = {isa = PBXBuildFile; fileRef = «IOSGeneratorUtil.getUuid(caName + ".swift")» /* «caName».swift */; };
		«ENDFOR»
		595E26E21B7D135D004F484A /* MD2WorkflowEventHandler.swift in Sources */ = {isa = PBXBuildFile; fileRef = 595E26E11B7D135D004F484A /* MD2WorkflowEventHandler.swift */; };
		595E26E41B7D1433004F484A /* MD2WorkflowElement.swift in Sources */ = {isa = PBXBuildFile; fileRef = 595E26E31B7D1433004F484A /* MD2WorkflowElement.swift */; };
		595E26E61B7D14DF004F484A /* MD2WorkflowEvent.swift in Sources */ = {isa = PBXBuildFile; fileRef = 595E26E51B7D14DF004F484A /* MD2WorkflowEvent.swift */; };
		595E26E81B7D197C004F484A /* MD2WorkflowAction.swift in Sources */ = {isa = PBXBuildFile; fileRef = 595E26E71B7D197C004F484A /* MD2WorkflowAction.swift */; };
		59C1EA2D1B7E45E3003DADDF /* MD2Event.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C1EA2C1B7E45E3003DADDF /* MD2Event.swift */; };
		59C1EA2F1B7E5751003DADDF /* MD2WorkflowManager.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C1EA2E1B7E5750003DADDF /* MD2WorkflowManager.swift */; };
		59C3D5B91B67E86400C5A613 /* MD2Widget.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C3D5B81B67E86300C5A613 /* MD2Widget.swift */; };
		59C3D5BB1B67FC0C00C5A613 /* MD2WidgetRegistry.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C3D5BA1B67FC0C00C5A613 /* MD2WidgetRegistry.swift */; };
		59C3D5BD1B67FDFB00C5A613 /* MD2ViewManager.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C3D5BC1B67FDFB00C5A613 /* MD2ViewManager.swift */; };
		59C3D5BF1B6802DB00C5A613 /* MD2Layout.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C3D5BE1B6802DB00C5A613 /* MD2Layout.swift */; };
		59C3D5C11B68035600C5A613 /* MD2SingleWidget.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C3D5C01B68035600C5A613 /* MD2SingleWidget.swift */; };
		59C3D5C31B680E4400C5A613 /* MD2FlowLayoutPane.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C3D5C21B680E4400C5A613 /* MD2FlowLayoutPane.swift */; };
		59C3D5D21B691FC100C5A613 /* MD2LabelWidget.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C3D5D11B691FC100C5A613 /* MD2LabelWidget.swift */; };
		59C3D5D41B69260D00C5A613 /* MD2ButtonWidget.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C3D5D31B69260D00C5A613 /* MD2ButtonWidget.swift */; };
		59C3D5D61B6966C000C5A613 /* MD2TextFieldWidget.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C3D5D51B6966BF00C5A613 /* MD2TextFieldWidget.swift */; };
		59C3D5D81B69681300C5A613 /* MD2SwitchWidget.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C3D5D71B69681300C5A613 /* MD2SwitchWidget.swift */; };
		59C3D5DC1B696FDF00C5A613 /* MD2ImageWidget.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C3D5DB1B696FDF00C5A613 /* MD2ImageWidget.swift */; };
		59C3D5E01B698C9900C5A613 /* MD2OnClickHandler.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C3D5DF1B698C9800C5A613 /* MD2OnClickHandler.swift */; };
		59C3D5E21B6AB3DE00C5A613 /* MD2WidgetMapping.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C3D5E11B6AB3DE00C5A613 /* MD2WidgetMapping.swift */; };
		59C3D5E51B6F736900C5A613 /* MD2UIUtil.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C3D5E41B6F736900C5A613 /* MD2UIUtil.swift */; };
		59C3D5E71B6F739D00C5A613 /* MD2Dimension.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C3D5E61B6F739D00C5A613 /* MD2Dimension.swift */; };
		59C3D5E91B6F840300C5A613 /* MD2ViewConfig.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C3D5E81B6F840300C5A613 /* MD2ViewConfig.swift */; };
		59C3D5EB1B6F84EA00C5A613 /* MD2SpacerWidget.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C3D5EA1B6F84EA00C5A613 /* MD2SpacerWidget.swift */; };
		59C3D5ED1B6FAB4B00C5A613 /* MD2GridLayoutPane.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C3D5EC1B6FAB4B00C5A613 /* MD2GridLayoutPane.swift */; };
		59C3D5EF1B6FBA2700C5A613 /* MD2OptionWidget.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C3D5EE1B6FBA2700C5A613 /* MD2OptionWidget.swift */; };
		59C3D5F11B6FBF6C00C5A613 /* MD2DateTimePickerWidget.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C3D5F01B6FBF6C00C5A613 /* MD2DateTimePickerWidget.swift */; };
		59C6A0D41B7B9FEF0038E056 /* MD2UpdateWidgetAction.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C6A0D31B7B9FEF0038E056 /* MD2UpdateWidgetAction.swift */; };
		59C6A0D61B7BA54B0038E056 /* MD2UpdateContentProviderAction.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59C6A0D51B7BA54B0038E056 /* MD2UpdateContentProviderAction.swift */; };
		59CB70721B5E9889001D312F /* MD2ViewController.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70701B5E9889001D312F /* MD2ViewController.swift */; };
		59CB707E1B5EAE2D001D312F /* MD2Type.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB707D1B5EAE2D001D312F /* MD2Type.swift */; };
		59CB70801B5EB15C001D312F /* MD2DataType.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB707F1B5EB15C001D312F /* MD2DataType.swift */; };
		59CB70821B5EB281001D312F /* MD2NumericType.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70811B5EB281001D312F /* MD2NumericType.swift */; };
		59CB70841B5EB321001D312F /* MD2Enum.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70831B5EB321001D312F /* MD2Enum.swift */; };
		59CB70861B5EB3CD001D312F /* MD2String.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70851B5EB3CD001D312F /* MD2String.swift */; };
		59CB70881B5EB72B001D312F /* MD2Boolean.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70871B5EB72B001D312F /* MD2Boolean.swift */; };
		59CB708A1B5EB78D001D312F /* MD2Integer.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70891B5EB78D001D312F /* MD2Integer.swift */; };
		59CB708C1B5F8E23001D312F /* MD2Float.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB708B1B5F8E22001D312F /* MD2Float.swift */; };
		59CB708E1B5F8FE8001D312F /* MD2Date.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB708D1B5F8FE8001D312F /* MD2Date.swift */; };
		59CB70901B5F97A6001D312F /* MD2Time.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB708F1B5F97A6001D312F /* MD2Time.swift */; };
		59CB70921B5F9932001D312F /* MD2DateTime.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70911B5F9932001D312F /* MD2DateTime.swift */; };
		59CB70941B5F9995001D312F /* MD2Entity.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70931B5F9995001D312F /* MD2Entity.swift */; };
		59CB70961B5FA283001D312F /* MD2Location.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70951B5FA282001D312F /* MD2Location.swift */; };
		59CB70981B5FB25B001D312F /* MD2ContentProvider.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70971B5FB25B001D312F /* MD2ContentProvider.swift */; };
		59CB709A1B5FB6E5001D312F /* MD2DataStore.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70991B5FB6E5001D312F /* MD2DataStore.swift */; };
		59CB709C1B5FB7B3001D312F /* MD2Filter.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB709B1B5FB7B3001D312F /* MD2Filter.swift */; };
		59CB709E1B5FB82B001D312F /* MD2Query.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB709D1B5FB82B001D312F /* MD2Query.swift */; };
		59CB70A01B5FBBAF001D312F /* MD2DataStoreFactory.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB709F1B5FBBAF001D312F /* MD2DataStoreFactory.swift */; };
		59CB70A41B5FBC6A001D312F /* MD2LocalStore.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70A31B5FBC6A001D312F /* MD2LocalStore.swift */; };
		59CB70A61B5FCC95001D312F /* MD2ContentProviderRegistry.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70A51B5FCC95001D312F /* MD2ContentProviderRegistry.swift */; };
		59CB70A81B5FDD37001D312F /* MD2Controller.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70A71B5FDD37001D312F /* MD2Controller.swift */; };
		59CB70AA1B5FDD63001D312F /* MD2Action.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70A91B5FDD63001D312F /* MD2Action.swift */; };
		59CB70AC1B5FDEA0001D312F /* MD2GotoViewAction.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70AB1B5FDE9F001D312F /* MD2GotoViewAction.swift */; };
		59CB70AE1B5FDF2A001D312F /* MD2DataMapper.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70AD1B5FDF2A001D312F /* MD2DataMapper.swift */; };
		59CB70B01B5FE271001D312F /* MD2WidgetWrapper.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70AF1B5FE271001D312F /* MD2WidgetWrapper.swift */; };
		59CB70B31B5FE3B9001D312F /* MD2Validator.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70B21B5FE3B9001D312F /* MD2Validator.swift */; };
		59CB70B51B5FE4C3001D312F /* MD2NotNullValidator.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70B41B5FE4C3001D312F /* MD2NotNullValidator.swift */; };
		59CB70B71B60CDE6001D312F /* MD2StringRangeValidator.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CB70B61B60CDE5001D312F /* MD2StringRangeValidator.swift */; };
		59CD55A61B5E8258007B9834 /* AppDelegate.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CD55A51B5E8258007B9834 /* AppDelegate.swift */; };
		59CD55AD1B5E8258007B9834 /* Images.xcassets in Resources */ = {isa = PBXBuildFile; fileRef = 59CD55AC1B5E8258007B9834 /* Images.xcassets */; };
		59CD55BC1B5E8259007B9834 /* «Settings.XCODE_TARGET_TEST».swift in Sources */ = {isa = PBXBuildFile; fileRef = «IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_TEST + ".swift")» /* «Settings.XCODE_TARGET_TEST».swift */; };
		59CE10111B60D71400ACE1E7 /* MD2NumberRangeValidator.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CE10101B60D71400ACE1E7 /* MD2NumberRangeValidator.swift */; };
		59CE10131B60D88500ACE1E7 /* MD2DateRangeValidator.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CE10121B60D88400ACE1E7 /* MD2DateRangeValidator.swift */; };
		59CE10151B60DD5800ACE1E7 /* MD2RegExValidator.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CE10141B60DD5600ACE1E7 /* MD2RegExValidator.swift */; };
		59CE10171B60DFAC00ACE1E7 /* MD2RegEx.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CE10161B60DFAB00ACE1E7 /* MD2RegEx.swift */; };
		59CE10191B60E31000ACE1E7 /* MD2TimeRangeValidator.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CE10181B60E31000ACE1E7 /* MD2TimeRangeValidator.swift */; };
		59CE101B1B60E35500ACE1E7 /* MD2DateTimeValidator.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CE101A1B60E35500ACE1E7 /* MD2DateTimeValidator.swift */; };
		59CE101D1B60E87300ACE1E7 /* MD2EventHandler.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CE101C1B60E87300ACE1E7 /* MD2EventHandler.swift */; };
		59CE101F1B60E89000ACE1E7 /* MD2GlobalEventHandler.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CE101E1B60E89000ACE1E7 /* MD2GlobalEventHandler.swift */; };
		59CE10211B60E8F500ACE1E7 /* MD2WidgetEventHandler.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CE10201B60E8F500ACE1E7 /* MD2WidgetEventHandler.swift */; };
		59CE10231B60E95500ACE1E7 /* MD2ContentProviderEventHandler.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CE10221B60E95500ACE1E7 /* MD2ContentProviderEventHandler.swift */; };
		59CE10251B60E9EA00ACE1E7 /* MD2OnWidgetChangeHandler.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59CE10241B60E9EA00ACE1E7 /* MD2OnWidgetChangeHandler.swift */; };
		59D007061B6FCE5400FA922D /* MD2WidgetTextStyle.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59D007051B6FCE5400FA922D /* MD2WidgetTextStyle.swift */; };
		59D0070A1B6FCFFA00FA922D /* MD2UIColorExtension.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59D007091B6FCFFA00FA922D /* MD2UIColorExtension.swift */; };
		59D0070C1B6FD87600FA922D /* MD2StylableWidget.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59D0070B1B6FD87600FA922D /* MD2StylableWidget.swift */; };
		59D363E71B77AAB300E51E19 /* LocalData.xcdatamodeld in Sources */ = {isa = PBXBuildFile; fileRef = 59D363E51B77AAB200E51E19 /* LocalData.xcdatamodeld */; };
		59D363ED1B78C2BB00E51E19 /* MD2Util.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59D363EC1B78C2BB00E51E19 /* MD2Util.swift */; };
		59DF70441B725A7E00F6F0A3 /* MD2ContentProviderOperationAction.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF70431B725A7E00F6F0A3 /* MD2ContentProviderOperationAction.swift */; };
		59DF70461B725C0300F6F0A3 /* MD2NewObjectAction.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF70451B725C0300F6F0A3 /* MD2NewObjectAction.swift */; };
		59DF70481B7260FB00F6F0A3 /* MD2AssignObjectAction.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF70471B7260FB00F6F0A3 /* MD2AssignObjectAction.swift */; };
		59DF704A1B72643900F6F0A3 /* MD2SetWorkflowElementAction.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF70491B72643900F6F0A3 /* MD2SetWorkflowElementAction.swift */; };
		59DF704C1B7264C100F6F0A3 /* MD2OnLeftSwipeHandler.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF704B1B7264C100F6F0A3 /* MD2OnLeftSwipeHandler.swift */; };
		59DF704E1B7264DE00F6F0A3 /* MD2OnRightSwipeHandler.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF704D1B7264DD00F6F0A3 /* MD2OnRightSwipeHandler.swift */; };
		59DF70501B72650B00F6F0A3 /* MD2OnConnectionLostHandler.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF704F1B72650B00F6F0A3 /* MD2OnConnectionLostHandler.swift */; };
		59DF70521B7265CC00F6F0A3 /* MD2OnConnectionRegainedHandler.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF70511B7265CC00F6F0A3 /* MD2OnConnectionRegainedHandler.swift */; };
		59DF70541B7265E800F6F0A3 /* MD2OnLocationUpdateHandler.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF70531B7265E800F6F0A3 /* MD2OnLocationUpdateHandler.swift */; };
		59DF70561B72687400F6F0A3 /* MD2DisableAction.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF70551B72687300F6F0A3 /* MD2DisableAction.swift */; };
		59DF70581B72698B00F6F0A3 /* MD2EnableAction.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF70571B72698B00F6F0A3 /* MD2EnableAction.swift */; };
		59DF705A1B7269AC00F6F0A3 /* MD2DisplayMessageAction.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF70591B7269AC00F6F0A3 /* MD2DisplayMessageAction.swift */; };
		59DF705C1B726A2900F6F0A3 /* MD2ContentProviderResetAction.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF705B1B726A2900F6F0A3 /* MD2ContentProviderResetAction.swift */; };
		59DF705E1B726A6900F6F0A3 /* MD2FireEventAction.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF705D1B726A6900F6F0A3 /* MD2FireEventAction.swift */; };
		59DF70601B726AE600F6F0A3 /* MD2WebServiceCallAction.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF705F1B726AE600F6F0A3 /* MD2WebServiceCallAction.swift */; };
		59DF70621B726B3100F6F0A3 /* MD2LocationAction.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF70611B726B3100F6F0A3 /* MD2LocationAction.swift */; };
		59DF70641B726EB300F6F0A3 /* MD2OnWrongValidationHandler.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF70631B726EB300F6F0A3 /* MD2OnWrongValidationHandler.swift */; };
		59DF70661B726F2A00F6F0A3 /* MD2IsNumberValidator.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF70651B726F2A00F6F0A3 /* MD2IsNumberValidator.swift */; };
		59DF70681B7270A300F6F0A3 /* MD2IsDateValidator.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF70671B7270A300F6F0A3 /* MD2IsDateValidator.swift */; };
		59DF706A1B72711100F6F0A3 /* MD2TemporalType.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF70691B72711100F6F0A3 /* MD2TemporalType.swift */; };
		59DF706C1B7283D600F6F0A3 /* MD2ModelConfig.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF706B1B7283D600F6F0A3 /* MD2ModelConfig.swift */; };
		59DF706E1B73552B00F6F0A3 /* MD2AssistedWidget.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF706D1B73552B00F6F0A3 /* MD2AssistedWidget.swift */; };
		59DF70701B7363E800F6F0A3 /* MD2TooltipHandler.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF706F1B7363E800F6F0A3 /* MD2TooltipHandler.swift */; };
		59DF70741B73C73A00F6F0A3 /* MD2OnContentChangeHandler.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF70731B73C73A00F6F0A3 /* MD2OnContentChangeHandler.swift */; };
		59DF70761B73C82600F6F0A3 /* MD2ContentProviderAttributeIdentity.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59DF70751B73C82600F6F0A3 /* MD2ContentProviderAttributeIdentity.swift */; };
		59E30B781BB04954005C8D47 /* MD2CombinedAction.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59E30B771BB04954005C8D47 /* MD2CombinedAction.swift */; };
		59FA44841B8F41640000CF02 /* MD2RestClient.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59FA44831B8F41630000CF02 /* MD2RestClient.swift */; };
		59FA44861B8F42430000CF02 /* SwiftyJSON.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59FA44851B8F42430000CF02 /* SwiftyJSON.swift */; };
		59FA448A1B8F54AE0000CF02 /* MD2RemoteStore.swift in Sources */ = {isa = PBXBuildFile; fileRef = 59FA44891B8F54AE0000CF02 /* MD2RemoteStore.swift */; };
/* End PBXBuildFile section */

/* Begin PBXContainerItemProxy section */
		59CD55B61B5E8259007B9834 /* PBXContainerItemProxy */ = {
			isa = PBXContainerItemProxy;
			containerPortal = 59CD55981B5E8258007B9834 /* Project object */;
			proxyType = 1;
			remoteGlobalIDString = «IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_APP + "__target")»;
			remoteInfo = "«Settings.APP_NAME»";
		};
/* End PBXContainerItemProxy section */

/* Begin PBXFileReference section */
		«FOR entity : container.entities»«val entityName = Settings.PREFIX_ENTITY + entity.name.toFirstUpper + ".swift"»
		«IOSGeneratorUtil.getUuid(entityName)» /* «entityName» */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = "«entityName»"; sourceTree = "<group>"; };
		«ENDFOR»
		«FOR e : container.enums»«val enumName = Settings.PREFIX_ENUM + e.name.toFirstUpper + ".swift"»
		«IOSGeneratorUtil.getUuid(enumName)» /* «enumName» */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = "«enumName»"; sourceTree = "<group>"; };
		«ENDFOR»
		«FOR cp : container.contentProviders»«val cpName = Settings.PREFIX_CONTENT_PROVIDER + cp.name.toFirstUpper + ".swift"»
		«IOSGeneratorUtil.getUuid(cpName)» /* «cpName» */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = "«cpName»"; sourceTree = "<group>"; };
		«ENDFOR»
		«FOR ca : app.workflowElements.map[wfe | wfe.workflowElementReference.actions.filter(CustomAction)].flatten»«val caName = Settings.PREFIX_CUSTOM_ACTION + ca.name.toFirstUpper + ".swift"»
		«IOSGeneratorUtil.getUuid(caName)» /* «caName» */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = "«caName»"; sourceTree = "<group>"; };
		«ENDFOR»
		595E26E11B7D135D004F484A /* MD2WorkflowEventHandler.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2WorkflowEventHandler.swift; sourceTree = "<group>"; };
		595E26E31B7D1433004F484A /* MD2WorkflowElement.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2WorkflowElement.swift; sourceTree = "<group>"; };
		595E26E51B7D14DF004F484A /* MD2WorkflowEvent.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2WorkflowEvent.swift; sourceTree = "<group>"; };
		595E26E71B7D197C004F484A /* MD2WorkflowAction.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2WorkflowAction.swift; sourceTree = "<group>"; };
		59C1EA2C1B7E45E3003DADDF /* MD2Event.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2Event.swift; sourceTree = "<group>"; };
		59C1EA2E1B7E5750003DADDF /* MD2WorkflowManager.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2WorkflowManager.swift; sourceTree = "<group>"; };
		59C3D5B81B67E86300C5A613 /* MD2Widget.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2Widget.swift; sourceTree = "<group>"; };
		59C3D5BA1B67FC0C00C5A613 /* MD2WidgetRegistry.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2WidgetRegistry.swift; sourceTree = "<group>"; };
		59C3D5BC1B67FDFB00C5A613 /* MD2ViewManager.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2ViewManager.swift; sourceTree = "<group>"; };
		59C3D5BE1B6802DB00C5A613 /* MD2Layout.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2Layout.swift; sourceTree = "<group>"; };
		59C3D5C01B68035600C5A613 /* MD2SingleWidget.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2SingleWidget.swift; sourceTree = "<group>"; };
		59C3D5C21B680E4400C5A613 /* MD2FlowLayoutPane.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2FlowLayoutPane.swift; sourceTree = "<group>"; };
		59C3D5D11B691FC100C5A613 /* MD2LabelWidget.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2LabelWidget.swift; sourceTree = "<group>"; };
		59C3D5D31B69260D00C5A613 /* MD2ButtonWidget.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2ButtonWidget.swift; sourceTree = "<group>"; };
		59C3D5D51B6966BF00C5A613 /* MD2TextFieldWidget.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2TextFieldWidget.swift; sourceTree = "<group>"; };
		59C3D5D71B69681300C5A613 /* MD2SwitchWidget.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2SwitchWidget.swift; sourceTree = "<group>"; };
		59C3D5DB1B696FDF00C5A613 /* MD2ImageWidget.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2ImageWidget.swift; sourceTree = "<group>"; };
		59C3D5DF1B698C9800C5A613 /* MD2OnClickHandler.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2OnClickHandler.swift; sourceTree = "<group>"; };
		59C3D5E11B6AB3DE00C5A613 /* MD2WidgetMapping.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2WidgetMapping.swift; sourceTree = "<group>"; };
		59C3D5E41B6F736900C5A613 /* MD2UIUtil.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2UIUtil.swift; sourceTree = "<group>"; };
		59C3D5E61B6F739D00C5A613 /* MD2Dimension.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2Dimension.swift; sourceTree = "<group>"; };
		59C3D5E81B6F840300C5A613 /* MD2ViewConfig.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2ViewConfig.swift; sourceTree = "<group>"; };
		59C3D5EA1B6F84EA00C5A613 /* MD2SpacerWidget.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2SpacerWidget.swift; sourceTree = "<group>"; };
		59C3D5EC1B6FAB4B00C5A613 /* MD2GridLayoutPane.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2GridLayoutPane.swift; sourceTree = "<group>"; };
		59C3D5EE1B6FBA2700C5A613 /* MD2OptionWidget.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2OptionWidget.swift; sourceTree = "<group>"; };
		59C3D5F01B6FBF6C00C5A613 /* MD2DateTimePickerWidget.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2DateTimePickerWidget.swift; sourceTree = "<group>"; };
		59C6A0D31B7B9FEF0038E056 /* MD2UpdateWidgetAction.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2UpdateWidgetAction.swift; sourceTree = "<group>"; };
		59C6A0D51B7BA54B0038E056 /* MD2UpdateContentProviderAction.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2UpdateContentProviderAction.swift; sourceTree = "<group>"; };
		59CB70701B5E9889001D312F /* MD2ViewController.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2ViewController.swift; sourceTree = "<group>"; };
		59CB707D1B5EAE2D001D312F /* MD2Type.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2Type.swift; sourceTree = "<group>"; };
		59CB707F1B5EB15C001D312F /* MD2DataType.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2DataType.swift; sourceTree = "<group>"; };
		59CB70811B5EB281001D312F /* MD2NumericType.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2NumericType.swift; sourceTree = "<group>"; };
		59CB70831B5EB321001D312F /* MD2Enum.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2Enum.swift; sourceTree = "<group>"; };
		59CB70851B5EB3CD001D312F /* MD2String.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2String.swift; sourceTree = "<group>"; };
		59CB70871B5EB72B001D312F /* MD2Boolean.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2Boolean.swift; sourceTree = "<group>"; };
		59CB70891B5EB78D001D312F /* MD2Integer.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2Integer.swift; sourceTree = "<group>"; };
		59CB708B1B5F8E22001D312F /* MD2Float.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2Float.swift; sourceTree = "<group>"; };
		59CB708D1B5F8FE8001D312F /* MD2Date.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2Date.swift; sourceTree = "<group>"; };
		59CB708F1B5F97A6001D312F /* MD2Time.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2Time.swift; sourceTree = "<group>"; };
		59CB70911B5F9932001D312F /* MD2DateTime.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2DateTime.swift; sourceTree = "<group>"; };
		59CB70931B5F9995001D312F /* MD2Entity.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2Entity.swift; sourceTree = "<group>"; };
		59CB70951B5FA282001D312F /* MD2Location.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2Location.swift; sourceTree = "<group>"; };
		59CB70971B5FB25B001D312F /* MD2ContentProvider.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2ContentProvider.swift; sourceTree = "<group>"; };
		59CB70991B5FB6E5001D312F /* MD2DataStore.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2DataStore.swift; sourceTree = "<group>"; };
		59CB709B1B5FB7B3001D312F /* MD2Filter.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2Filter.swift; sourceTree = "<group>"; };
		59CB709D1B5FB82B001D312F /* MD2Query.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2Query.swift; sourceTree = "<group>"; };
		59CB709F1B5FBBAF001D312F /* MD2DataStoreFactory.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2DataStoreFactory.swift; sourceTree = "<group>"; };
		59CB70A31B5FBC6A001D312F /* MD2LocalStore.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2LocalStore.swift; sourceTree = "<group>"; };
		59CB70A51B5FCC95001D312F /* MD2ContentProviderRegistry.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2ContentProviderRegistry.swift; sourceTree = "<group>"; };
		59CB70A71B5FDD37001D312F /* MD2Controller.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2Controller.swift; sourceTree = "<group>"; };
		59CB70A91B5FDD63001D312F /* MD2Action.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2Action.swift; sourceTree = "<group>"; };
		59CB70AB1B5FDE9F001D312F /* MD2GotoViewAction.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2GotoViewAction.swift; sourceTree = "<group>"; };
		59CB70AD1B5FDF2A001D312F /* MD2DataMapper.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2DataMapper.swift; sourceTree = "<group>"; };
		59CB70AF1B5FE271001D312F /* MD2WidgetWrapper.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2WidgetWrapper.swift; sourceTree = "<group>"; };
		59CB70B21B5FE3B9001D312F /* MD2Validator.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2Validator.swift; sourceTree = "<group>"; };
		59CB70B41B5FE4C3001D312F /* MD2NotNullValidator.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2NotNullValidator.swift; sourceTree = "<group>"; };
		59CB70B61B60CDE5001D312F /* MD2StringRangeValidator.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2StringRangeValidator.swift; sourceTree = "<group>"; };
		«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_APP + ".app")» /* «Settings.XCODE_TARGET_APP».app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = "md2-ios-refereceimpl.app"; sourceTree = BUILT_PRODUCTS_DIR; };
		59CD55A41B5E8258007B9834 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
		59CD55A51B5E8258007B9834 /* AppDelegate.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AppDelegate.swift; sourceTree = "<group>"; };
		59CD55AC1B5E8258007B9834 /* Images.xcassets */ = {isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Images.xcassets; sourceTree = "<group>"; };
		«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_APP + ".xctest")» /* «Settings.XCODE_TARGET_TEST».xctest */ = {isa = PBXFileReference; explicitFileType = wrapper.cfbundle; includeInIndex = 0; path = "«Settings.XCODE_TARGET_TEST».xctest"; sourceTree = BUILT_PRODUCTS_DIR; };
		59CD55BA1B5E8259007B9834 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
		«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_APP + ".swift")» /* «Settings.XCODE_TARGET_TEST».swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = «Settings.XCODE_TARGET_TEST».swift; sourceTree = "<group>"; };
		59CE10101B60D71400ACE1E7 /* MD2NumberRangeValidator.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2NumberRangeValidator.swift; sourceTree = "<group>"; };
		59CE10121B60D88400ACE1E7 /* MD2DateRangeValidator.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2DateRangeValidator.swift; sourceTree = "<group>"; };
		59CE10141B60DD5600ACE1E7 /* MD2RegExValidator.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2RegExValidator.swift; sourceTree = "<group>"; };
		59CE10161B60DFAB00ACE1E7 /* MD2RegEx.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2RegEx.swift; sourceTree = "<group>"; };
		59CE10181B60E31000ACE1E7 /* MD2TimeRangeValidator.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2TimeRangeValidator.swift; sourceTree = "<group>"; };
		59CE101A1B60E35500ACE1E7 /* MD2DateTimeValidator.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2DateTimeValidator.swift; sourceTree = "<group>"; };
		59CE101C1B60E87300ACE1E7 /* MD2EventHandler.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2EventHandler.swift; sourceTree = "<group>"; };
		59CE101E1B60E89000ACE1E7 /* MD2GlobalEventHandler.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2GlobalEventHandler.swift; sourceTree = "<group>"; };
		59CE10201B60E8F500ACE1E7 /* MD2WidgetEventHandler.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2WidgetEventHandler.swift; sourceTree = "<group>"; };
		59CE10221B60E95500ACE1E7 /* MD2ContentProviderEventHandler.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2ContentProviderEventHandler.swift; sourceTree = "<group>"; };
		59CE10241B60E9EA00ACE1E7 /* MD2OnWidgetChangeHandler.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2OnWidgetChangeHandler.swift; sourceTree = "<group>"; };
		59D007051B6FCE5400FA922D /* MD2WidgetTextStyle.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2WidgetTextStyle.swift; sourceTree = "<group>"; };
		59D007091B6FCFFA00FA922D /* MD2UIColorExtension.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2UIColorExtension.swift; sourceTree = "<group>"; };
		59D0070B1B6FD87600FA922D /* MD2StylableWidget.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2StylableWidget.swift; sourceTree = "<group>"; };
		59D363E61B77AAB300E51E19 /* LocalData.xcdatamodel */ = {isa = PBXFileReference; lastKnownFileType = wrapper.xcdatamodel; path = LocalData.xcdatamodel; sourceTree = "<group>"; };
		59D363EC1B78C2BB00E51E19 /* MD2Util.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2Util.swift; sourceTree = "<group>"; };
		59DF70431B725A7E00F6F0A3 /* MD2ContentProviderOperationAction.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2ContentProviderOperationAction.swift; sourceTree = "<group>"; };
		59DF70451B725C0300F6F0A3 /* MD2NewObjectAction.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2NewObjectAction.swift; sourceTree = "<group>"; };
		59DF70471B7260FB00F6F0A3 /* MD2AssignObjectAction.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2AssignObjectAction.swift; sourceTree = "<group>"; };
		59DF70491B72643900F6F0A3 /* MD2SetWorkflowElementAction.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2SetWorkflowElementAction.swift; sourceTree = "<group>"; };
		59DF704B1B7264C100F6F0A3 /* MD2OnLeftSwipeHandler.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2OnLeftSwipeHandler.swift; sourceTree = "<group>"; };
		59DF704D1B7264DD00F6F0A3 /* MD2OnRightSwipeHandler.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2OnRightSwipeHandler.swift; sourceTree = "<group>"; };
		59DF704F1B72650B00F6F0A3 /* MD2OnConnectionLostHandler.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2OnConnectionLostHandler.swift; sourceTree = "<group>"; };
		59DF70511B7265CC00F6F0A3 /* MD2OnConnectionRegainedHandler.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2OnConnectionRegainedHandler.swift; sourceTree = "<group>"; };
		59DF70531B7265E800F6F0A3 /* MD2OnLocationUpdateHandler.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2OnLocationUpdateHandler.swift; sourceTree = "<group>"; };
		59DF70551B72687300F6F0A3 /* MD2DisableAction.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2DisableAction.swift; sourceTree = "<group>"; };
		59DF70571B72698B00F6F0A3 /* MD2EnableAction.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2EnableAction.swift; sourceTree = "<group>"; };
		59DF70591B7269AC00F6F0A3 /* MD2DisplayMessageAction.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2DisplayMessageAction.swift; sourceTree = "<group>"; };
		59DF705B1B726A2900F6F0A3 /* MD2ContentProviderResetAction.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2ContentProviderResetAction.swift; sourceTree = "<group>"; };
		59DF705D1B726A6900F6F0A3 /* MD2FireEventAction.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2FireEventAction.swift; sourceTree = "<group>"; };
		59DF705F1B726AE600F6F0A3 /* MD2WebServiceCallAction.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2WebServiceCallAction.swift; sourceTree = "<group>"; };
		59DF70611B726B3100F6F0A3 /* MD2LocationAction.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2LocationAction.swift; sourceTree = "<group>"; };
		59DF70631B726EB300F6F0A3 /* MD2OnWrongValidationHandler.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2OnWrongValidationHandler.swift; sourceTree = "<group>"; };
		59DF70651B726F2A00F6F0A3 /* MD2IsNumberValidator.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2IsNumberValidator.swift; sourceTree = "<group>"; };
		59DF70671B7270A300F6F0A3 /* MD2IsDateValidator.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2IsDateValidator.swift; sourceTree = "<group>"; };
		59DF70691B72711100F6F0A3 /* MD2TemporalType.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2TemporalType.swift; sourceTree = "<group>"; };
		59DF706B1B7283D600F6F0A3 /* MD2ModelConfig.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2ModelConfig.swift; sourceTree = "<group>"; };
		59DF706D1B73552B00F6F0A3 /* MD2AssistedWidget.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2AssistedWidget.swift; sourceTree = "<group>"; };
		59DF706F1B7363E800F6F0A3 /* MD2TooltipHandler.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2TooltipHandler.swift; sourceTree = "<group>"; };
		59DF70731B73C73A00F6F0A3 /* MD2OnContentChangeHandler.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2OnContentChangeHandler.swift; sourceTree = "<group>"; };
		59DF70751B73C82600F6F0A3 /* MD2ContentProviderAttributeIdentity.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2ContentProviderAttributeIdentity.swift; sourceTree = "<group>"; };
		59E30B771BB04954005C8D47 /* MD2CombinedAction.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2CombinedAction.swift; sourceTree = "<group>"; };
		59FA44831B8F41630000CF02 /* MD2RestClient.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2RestClient.swift; sourceTree = "<group>"; };
		59FA44851B8F42430000CF02 /* SwiftyJSON.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = SwiftyJSON.swift; sourceTree = "<group>"; };
		59FA44891B8F54AE0000CF02 /* MD2RemoteStore.swift */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = MD2RemoteStore.swift; sourceTree = "<group>"; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		59CD559D1B5E8258007B9834 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
		59CD55B21B5E8259007B9834 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		595E26E01B7D1214004F484A /* workflow */ = {
			isa = PBXGroup;
			children = (
				595E26E71B7D197C004F484A /* MD2WorkflowAction.swift */,
				595E26E31B7D1433004F484A /* MD2WorkflowElement.swift */,
				59C1EA2E1B7E5750003DADDF /* MD2WorkflowManager.swift */,
				595E26E51B7D14DF004F484A /* MD2WorkflowEvent.swift */,
			);
			path = workflow;
			sourceTree = "<group>";
		};
		59C3D5C71B68B1C800C5A613 /* entity */ = {
			isa = PBXGroup;
			children = (
				«FOR entity : container.entities»«val entityName = Settings.PREFIX_ENTITY + entity.name.toFirstUpper + ".swift"»
				«IOSGeneratorUtil.getUuid(entityName)» /* «entityName» */,
				«ENDFOR»
				59CB70951B5FA282001D312F /* MD2Location.swift */,
			);
			path = entity;
			sourceTree = "<group>";
		};
		59C3D5CC1B68B27F00C5A613 /* enum */ = {
			isa = PBXGroup;
			children = (
				«FOR e : container.enums»«val enumName = Settings.PREFIX_ENTITY + e.name.toFirstUpper + ".swift"»
				«IOSGeneratorUtil.getUuid(enumName)» /* «enumName» */,
				«ENDFOR»
			);
			path = enum;
			sourceTree = "<group>";
		};
		59C3D5E31B6F733E00C5A613 /* util */ = {
			isa = PBXGroup;
			children = (
				59C3D5E41B6F736900C5A613 /* MD2UIUtil.swift */,
				59D363EC1B78C2BB00E51E19 /* MD2Util.swift */,
				59D007091B6FCFFA00FA922D /* MD2UIColorExtension.swift */,
				59FA44831B8F41630000CF02 /* MD2RestClient.swift */,
				59FA44851B8F42430000CF02 /* SwiftyJSON.swift */,
			);
			path = util;
			sourceTree = "<group>";
		};
		59CB70741B5E9DF1001D312F /* view */ = {
			isa = PBXGroup;
			children = (
				59D0070B1B6FD87600FA922D /* MD2StylableWidget.swift */,
				59DF706D1B73552B00F6F0A3 /* MD2AssistedWidget.swift */,
				59C3D5E11B6AB3DE00C5A613 /* MD2WidgetMapping.swift */,
				59D007051B6FCE5400FA922D /* MD2WidgetTextStyle.swift */,
				59C3D5E61B6F739D00C5A613 /* MD2Dimension.swift */,
				59CB707B1B5EADE8001D312F /* widget */,
				59C3D5BC1B67FDFB00C5A613 /* MD2ViewManager.swift */,
				59C3D5E81B6F840300C5A613 /* MD2ViewConfig.swift */,
			);
			path = view;
			sourceTree = "<group>";
		};
		59CB70751B5E9E11001D312F /* controller */ = {
			isa = PBXGroup;
			children = (
				59CB70701B5E9889001D312F /* MD2ViewController.swift */,
				59CB70B11B5FE396001D312F /* validator */,
				59CB707C1B5EADFE001D312F /* action */,
				59CB70791B5EAD52001D312F /* eventhandler */,
				59CB70A71B5FDD37001D312F /* MD2Controller.swift */,
				59CB70AD1B5FDF2A001D312F /* MD2DataMapper.swift */,
			);
			path = controller;
			sourceTree = "<group>";
		};
		59CB70761B5E9E29001D312F /* model */ = {
			isa = PBXGroup;
			children = (
				59C3D5CC1B68B27F00C5A613 /* enum */,
				59C3D5C71B68B1C800C5A613 /* entity */,
				59CB709D1B5FB82B001D312F /* MD2Query.swift */,
				59CB709B1B5FB7B3001D312F /* MD2Filter.swift */,
				59CB707A1B5EAD5F001D312F /* contentprovider */,
				59CB70781B5EAD19001D312F /* store */,
				59CB70771B5EACDC001D312F /* type */,
				59CE10161B60DFAB00ACE1E7 /* MD2RegEx.swift */,
				59DF706B1B7283D600F6F0A3 /* MD2ModelConfig.swift */,
				59DF70751B73C82600F6F0A3 /* MD2ContentProviderAttributeIdentity.swift */,
			);
			path = model;
			sourceTree = "<group>";
		};
		59CB70771B5EACDC001D312F /* type */ = {
			isa = PBXGroup;
			children = (
				59CB70871B5EB72B001D312F /* MD2Boolean.swift */,
				59CB707F1B5EB15C001D312F /* MD2DataType.swift */,
				59CB708D1B5F8FE8001D312F /* MD2Date.swift */,
				59CB70911B5F9932001D312F /* MD2DateTime.swift */,
				59CB70931B5F9995001D312F /* MD2Entity.swift */,
				59CB70831B5EB321001D312F /* MD2Enum.swift */,
				59CB708B1B5F8E22001D312F /* MD2Float.swift */,
				59CB70891B5EB78D001D312F /* MD2Integer.swift */,
				59CB70811B5EB281001D312F /* MD2NumericType.swift */,
				59DF70691B72711100F6F0A3 /* MD2TemporalType.swift */,
				59CB70851B5EB3CD001D312F /* MD2String.swift */,
				59CB708F1B5F97A6001D312F /* MD2Time.swift */,
				59CB707D1B5EAE2D001D312F /* MD2Type.swift */,
			);
			path = type;
			sourceTree = "<group>";
		};
		59CB70781B5EAD19001D312F /* store */ = {
			isa = PBXGroup;
			children = (
				59CB70991B5FB6E5001D312F /* MD2DataStore.swift */,
				59CB709F1B5FBBAF001D312F /* MD2DataStoreFactory.swift */,
				59CB70A31B5FBC6A001D312F /* MD2LocalStore.swift */,
				59D363E51B77AAB200E51E19 /* LocalData.xcdatamodeld */,
				59FA44891B8F54AE0000CF02 /* MD2RemoteStore.swift */,
			);
			name = store;
			path = datastore;
			sourceTree = "<group>";
		};
		59CB70791B5EAD52001D312F /* eventhandler */ = {
			isa = PBXGroup;
			children = (
				595E26E11B7D135D004F484A /* MD2WorkflowEventHandler.swift */,
				59CE101C1B60E87300ACE1E7 /* MD2EventHandler.swift */,
				59CE101E1B60E89000ACE1E7 /* MD2GlobalEventHandler.swift */,
				59CE10201B60E8F500ACE1E7 /* MD2WidgetEventHandler.swift */,
				59CE10221B60E95500ACE1E7 /* MD2ContentProviderEventHandler.swift */,
				59CE10241B60E9EA00ACE1E7 /* MD2OnWidgetChangeHandler.swift */,
				59C3D5DF1B698C9800C5A613 /* MD2OnClickHandler.swift */,
				59DF706F1B7363E800F6F0A3 /* MD2TooltipHandler.swift */,
				59DF704B1B7264C100F6F0A3 /* MD2OnLeftSwipeHandler.swift */,
				59DF704F1B72650B00F6F0A3 /* MD2OnConnectionLostHandler.swift */,
				59DF70511B7265CC00F6F0A3 /* MD2OnConnectionRegainedHandler.swift */,
				59DF70731B73C73A00F6F0A3 /* MD2OnContentChangeHandler.swift */,
				59DF70531B7265E800F6F0A3 /* MD2OnLocationUpdateHandler.swift */,
				59DF704D1B7264DD00F6F0A3 /* MD2OnRightSwipeHandler.swift */,
				59DF70631B726EB300F6F0A3 /* MD2OnWrongValidationHandler.swift */,
				59C1EA2C1B7E45E3003DADDF /* MD2Event.swift */,
			);
			path = eventhandler;
			sourceTree = "<group>";
		};
		59CB707A1B5EAD5F001D312F /* contentprovider */ = {
			isa = PBXGroup;
			children = (
				«FOR cp : container.enums»«val cpName = Settings.PREFIX_ENTITY + cp.name.toFirstUpper + ".swift"»
				«IOSGeneratorUtil.getUuid(cpName)» /* «cpName» */,
				«ENDFOR»
				59CB70971B5FB25B001D312F /* MD2ContentProvider.swift */,
				59CB70A51B5FCC95001D312F /* MD2ContentProviderRegistry.swift */,
			);
			path = contentprovider;
			sourceTree = "<group>";
		};
		59CB707B1B5EADE8001D312F /* widget */ = {
			isa = PBXGroup;
			children = (
				59CB70AF1B5FE271001D312F /* MD2WidgetWrapper.swift */,
				59C3D5BA1B67FC0C00C5A613 /* MD2WidgetRegistry.swift */,
				59C3D5B81B67E86300C5A613 /* MD2Widget.swift */,
				59C3D5BE1B6802DB00C5A613 /* MD2Layout.swift */,
				59C3D5C01B68035600C5A613 /* MD2SingleWidget.swift */,
				59C3D5C21B680E4400C5A613 /* MD2FlowLayoutPane.swift */,
				59C3D5EC1B6FAB4B00C5A613 /* MD2GridLayoutPane.swift */,
				59C3D5D11B691FC100C5A613 /* MD2LabelWidget.swift */,
				59C3D5EA1B6F84EA00C5A613 /* MD2SpacerWidget.swift */,
				59C3D5D31B69260D00C5A613 /* MD2ButtonWidget.swift */,
				59C3D5D51B6966BF00C5A613 /* MD2TextFieldWidget.swift */,
				59C3D5F01B6FBF6C00C5A613 /* MD2DateTimePickerWidget.swift */,
				59C3D5EE1B6FBA2700C5A613 /* MD2OptionWidget.swift */,
				59C3D5D71B69681300C5A613 /* MD2SwitchWidget.swift */,
				59C3D5DB1B696FDF00C5A613 /* MD2ImageWidget.swift */,
			);
			path = widget;
			sourceTree = "<group>";
		};
		59CB707C1B5EADFE001D312F /* action */ = {
			isa = PBXGroup;
			children = (
				«FOR ca : app.workflowElements.map[wfe | wfe.workflowElementReference.actions.filter(CustomAction)].flatten»«val caName = Settings.PREFIX_CUSTOM_ACTION + ca.name.toFirstUpper + ".swift"»
				«IOSGeneratorUtil.getUuid(caName)» /* «caName» */,
				«ENDFOR»
				59CB70A91B5FDD63001D312F /* MD2Action.swift */,
				59CB70AB1B5FDE9F001D312F /* MD2GotoViewAction.swift */,
				59DF70431B725A7E00F6F0A3 /* MD2ContentProviderOperationAction.swift */,
				59DF705B1B726A2900F6F0A3 /* MD2ContentProviderResetAction.swift */,
				59DF705D1B726A6900F6F0A3 /* MD2FireEventAction.swift */,
				59DF705F1B726AE600F6F0A3 /* MD2WebServiceCallAction.swift */,
				59DF70611B726B3100F6F0A3 /* MD2LocationAction.swift */,
				59DF70451B725C0300F6F0A3 /* MD2NewObjectAction.swift */,
				59DF70471B7260FB00F6F0A3 /* MD2AssignObjectAction.swift */,
				59DF70491B72643900F6F0A3 /* MD2SetWorkflowElementAction.swift */,
				59DF70551B72687300F6F0A3 /* MD2DisableAction.swift */,
				59DF70571B72698B00F6F0A3 /* MD2EnableAction.swift */,
				59C6A0D31B7B9FEF0038E056 /* MD2UpdateWidgetAction.swift */,
				59C6A0D51B7BA54B0038E056 /* MD2UpdateContentProviderAction.swift */,
				59DF70591B7269AC00F6F0A3 /* MD2DisplayMessageAction.swift */,
				59E30B771BB04954005C8D47 /* MD2CombinedAction.swift */,
			);
			path = action;
			sourceTree = "<group>";
		};
		59CB70B11B5FE396001D312F /* validator */ = {
			isa = PBXGroup;
			children = (
				59CB70B21B5FE3B9001D312F /* MD2Validator.swift */,
				59CB70B41B5FE4C3001D312F /* MD2NotNullValidator.swift */,
				59CB70B61B60CDE5001D312F /* MD2StringRangeValidator.swift */,
				59CE10101B60D71400ACE1E7 /* MD2NumberRangeValidator.swift */,
				59CE10141B60DD5600ACE1E7 /* MD2RegExValidator.swift */,
				59CE10121B60D88400ACE1E7 /* MD2DateRangeValidator.swift */,
				59CE10181B60E31000ACE1E7 /* MD2TimeRangeValidator.swift */,
				59CE101A1B60E35500ACE1E7 /* MD2DateTimeValidator.swift */,
				59DF70651B726F2A00F6F0A3 /* MD2IsNumberValidator.swift */,
				59DF70671B7270A300F6F0A3 /* MD2IsDateValidator.swift */,
			);
			path = validator;
			sourceTree = "<group>";
		};
		59CD55971B5E8258007B9834 = {
			isa = PBXGroup;
			children = (
				«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_APP + "/")» /* «Settings.XCODE_TARGET_APP» */,
				«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_TEST + "/")» /* «Settings.XCODE_TARGET_TEST» */,
				59CD55A11B5E8258007B9834 /* Products */,
			);
			sourceTree = "<group>";
		};
		59CD55A11B5E8258007B9834 /* Products */ = {
			isa = PBXGroup;
			children = (
				«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_APP + ".app")» /* «Settings.XCODE_TARGET_APP».app */,
				«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_TEST + ".xctest")» /* «Settings.XCODE_TARGET_TEST».xctest */,
			);
			name = Products;
			sourceTree = "<group>";
		};
		«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_APP + "/")» /* «Settings.XCODE_TARGET_APP» */ = {
			isa = PBXGroup;
			children = (
				595E26E01B7D1214004F484A /* workflow */,
				59C3D5E31B6F733E00C5A613 /* util */,
				59CD55A51B5E8258007B9834 /* AppDelegate.swift */,
				59CB70751B5E9E11001D312F /* controller */,
				59CD55AC1B5E8258007B9834 /* Images.xcassets */,
				59CB70761B5E9E29001D312F /* model */,
				59CD55A31B5E8258007B9834 /* Supporting Files */,
				59CB70741B5E9DF1001D312F /* view */,
			);
			path = "«Settings.XCODE_TARGET_APP»";
			sourceTree = "<group>";
		};
		59CD55A31B5E8258007B9834 /* Supporting Files */ = {
			isa = PBXGroup;
			children = (
				59CD55A41B5E8258007B9834 /* Info.plist */,
			);
			name = "Supporting Files";
			sourceTree = "<group>";
		};
		«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_TEST + "/")» /* «Settings.XCODE_TARGET_TEST» */ = {
			isa = PBXGroup;
			children = (
				«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_TEST + ".swift")» /* «Settings.XCODE_TARGET_TEST».swift */,
				59CD55B91B5E8259007B9834 /* Supporting Files */,
			);
			path = "«Settings.XCODE_TARGET_TEST»";
			sourceTree = "<group>";
		};
		59CD55B91B5E8259007B9834 /* Supporting Files */ = {
			isa = PBXGroup;
			children = (
				59CD55BA1B5E8259007B9834 /* Info.plist */,
			);
			name = "Supporting Files";
			sourceTree = "<group>";
		};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_APP + "__target")» /* «Settings.XCODE_TARGET_APP» */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = 59CD55BF1B5E8259007B9834 /* Build configuration list for PBXNativeTarget «Settings.XCODE_TARGET_APP»" */;
			buildPhases = (
				59CD559C1B5E8258007B9834 /* Sources */,
				59CD559D1B5E8258007B9834 /* Frameworks */,
				59CD559E1B5E8258007B9834 /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = "«Settings.XCODE_TARGET_APP»";
			productName = "«Settings.XCODE_TARGET_APP»";
			productReference = «IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_APP + ".app")» /* «Settings.XCODE_TARGET_APP».app */;
			productType = "com.apple.product-type.application";
		};
		«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_TEST + "__target")» /*  «Settings.XCODE_TARGET_TEST» */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = 59CD55C21B5E8259007B9834 /* Build configuration list for PBXNativeTarget "«Settings.XCODE_TARGET_TEST»" */;
			buildPhases = (
				59CD55B11B5E8259007B9834 /* Sources */,
				59CD55B21B5E8259007B9834 /* Frameworks */,
				59CD55B31B5E8259007B9834 /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
				59CD55B71B5E8259007B9834 /* PBXTargetDependency */,
			);
			name = "«Settings.XCODE_TARGET_TEST»";
			productName = "«Settings.XCODE_TARGET_TEST»";
			productReference = «IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_APP + ".xctest")» /* «Settings.XCODE_TARGET_TEST».xctest */;
			productType = "com.apple.product-type.bundle.unit-test";
		};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		59CD55981B5E8258007B9834 /* Project object */ = {
			isa = PBXProject;
			attributes = {
				LastUpgradeCheck = 0630;
				ORGANIZATIONNAME = "Christoph Rieger";
				TargetAttributes = {
					«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_APP + "__target")» = {
						CreatedOnToolsVersion = 6.3.2;
					};
					«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_TEST + "__target")» = {
						CreatedOnToolsVersion = 6.3.2;
						TestTargetID = «IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_APP + "__target")»;
					};
				};
			};
			buildConfigurationList = 59CD559B1B5E8258007B9834 /* Build configuration list for PBXProject "«Settings.APP_NAME»" */;
			compatibilityVersion = "Xcode 3.2";
			developmentRegion = English;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = 59CD55971B5E8258007B9834;
			productRefGroup = 59CD55A11B5E8258007B9834 /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_APP + "__target")» /* «Settings.XCODE_TARGET_APP» */,
				«IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_TEST + "__target")» /* «Settings.XCODE_TARGET_TEST» */,
			);
		};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		59CD559E1B5E8258007B9834 /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				59CD55AD1B5E8258007B9834 /* Images.xcassets in Resources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
		59CD55B31B5E8259007B9834 /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		59CD559C1B5E8258007B9834 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				«FOR entity : container.entities»«val entityName = Settings.PREFIX_ENTITY + entity.name.toFirstUpper»
				«IOSGeneratorUtil.getUuid(entityName)» /* «entityName» in Sources */,
				«ENDFOR»
				«FOR e : container.enums»«val enumName = Settings.PREFIX_ENUM + e.name.toFirstUpper»
				«IOSGeneratorUtil.getUuid(enumName)» /* «enumName» in Sources */,
				«ENDFOR»
				«FOR cp : container.contentProviders»«val cpName = Settings.PREFIX_CONTENT_PROVIDER + cp.name.toFirstUpper»
				«IOSGeneratorUtil.getUuid(cpName)» /* «cpName» in Sources */,
				«ENDFOR»
				«FOR ca : app.workflowElements.map[wfe | wfe.workflowElementReference.actions.filter(CustomAction)].flatten»«val caName = Settings.PREFIX_CUSTOM_ACTION + ca.name.toFirstUpper»
				«IOSGeneratorUtil.getUuid(caName)» /* «caName» in Sources */,
				«ENDFOR»
				59C3D5C11B68035600C5A613 /* MD2SingleWidget.swift in Sources */,
				59DF704C1B7264C100F6F0A3 /* MD2OnLeftSwipeHandler.swift in Sources */,
				59CB70A01B5FBBAF001D312F /* MD2DataStoreFactory.swift in Sources */,
				59DF705C1B726A2900F6F0A3 /* MD2ContentProviderResetAction.swift in Sources */,
				595E26E41B7D1433004F484A /* MD2WorkflowElement.swift in Sources */,
				59C3D5D81B69681300C5A613 /* MD2SwitchWidget.swift in Sources */,
				59C3D5DC1B696FDF00C5A613 /* MD2ImageWidget.swift in Sources */,
				59CB70AA1B5FDD63001D312F /* MD2Action.swift in Sources */,
				59DF70501B72650B00F6F0A3 /* MD2OnConnectionLostHandler.swift in Sources */,
				59CB70721B5E9889001D312F /* MD2ViewController.swift in Sources */,
				59CB70AE1B5FDF2A001D312F /* MD2DataMapper.swift in Sources */,
				59C3D5E71B6F739D00C5A613 /* MD2Dimension.swift in Sources */,
				59CD55A61B5E8258007B9834 /* AppDelegate.swift in Sources */,
				59C3D5EF1B6FBA2700C5A613 /* MD2OptionWidget.swift in Sources */,
				59DF704E1B7264DE00F6F0A3 /* MD2OnRightSwipeHandler.swift in Sources */,
				59CB70941B5F9995001D312F /* MD2Entity.swift in Sources */,
				59DF70541B7265E800F6F0A3 /* MD2OnLocationUpdateHandler.swift in Sources */,
				59C3D5E51B6F736900C5A613 /* MD2UIUtil.swift in Sources */,
				59CB70901B5F97A6001D312F /* MD2Time.swift in Sources */,
				59CB70B31B5FE3B9001D312F /* MD2Validator.swift in Sources */,
				59D0070C1B6FD87600FA922D /* MD2StylableWidget.swift in Sources */,
				59DF70561B72687400F6F0A3 /* MD2DisableAction.swift in Sources */,
				59CE10191B60E31000ACE1E7 /* MD2TimeRangeValidator.swift in Sources */,
				59CB70AC1B5FDEA0001D312F /* MD2GotoViewAction.swift in Sources */,
				59DF70701B7363E800F6F0A3 /* MD2TooltipHandler.swift in Sources */,
				59C3D5B91B67E86400C5A613 /* MD2Widget.swift in Sources */,
				59CB70A61B5FCC95001D312F /* MD2ContentProviderRegistry.swift in Sources */,
				59E30B781BB04954005C8D47 /* MD2CombinedAction.swift in Sources */,
				59CB70861B5EB3CD001D312F /* MD2String.swift in Sources */,
				59D363E71B77AAB300E51E19 /* LocalData.xcdatamodeld in Sources */,
				59CB708E1B5F8FE8001D312F /* MD2Date.swift in Sources */,
				59C3D5E21B6AB3DE00C5A613 /* MD2WidgetMapping.swift in Sources */,
				59DF706E1B73552B00F6F0A3 /* MD2AssistedWidget.swift in Sources */,
				59FA44861B8F42430000CF02 /* SwiftyJSON.swift in Sources */,
				59DF70681B7270A300F6F0A3 /* MD2IsDateValidator.swift in Sources */,
				59CE10231B60E95500ACE1E7 /* MD2ContentProviderEventHandler.swift in Sources */,
				59DF70581B72698B00F6F0A3 /* MD2EnableAction.swift in Sources */,
				59DF70761B73C82600F6F0A3 /* MD2ContentProviderAttributeIdentity.swift in Sources */,
				595E26E61B7D14DF004F484A /* MD2WorkflowEvent.swift in Sources */,
				59DF70621B726B3100F6F0A3 /* MD2LocationAction.swift in Sources */,
				59DF706C1B7283D600F6F0A3 /* MD2ModelConfig.swift in Sources */,
				59DF70661B726F2A00F6F0A3 /* MD2IsNumberValidator.swift in Sources */,
				59DF70441B725A7E00F6F0A3 /* MD2ContentProviderOperationAction.swift in Sources */,
				59CE10131B60D88500ACE1E7 /* MD2DateRangeValidator.swift in Sources */,
				59CB70981B5FB25B001D312F /* MD2ContentProvider.swift in Sources */,
				59DF70461B725C0300F6F0A3 /* MD2NewObjectAction.swift in Sources */,
				59DF705A1B7269AC00F6F0A3 /* MD2DisplayMessageAction.swift in Sources */,
				59D363ED1B78C2BB00E51E19 /* MD2Util.swift in Sources */,
				59CB709C1B5FB7B3001D312F /* MD2Filter.swift in Sources */,
				59C6A0D41B7B9FEF0038E056 /* MD2UpdateWidgetAction.swift in Sources */,
				59C1EA2F1B7E5751003DADDF /* MD2WorkflowManager.swift in Sources */,
				59CB709E1B5FB82B001D312F /* MD2Query.swift in Sources */,
				59CB70B01B5FE271001D312F /* MD2WidgetWrapper.swift in Sources */,
				59DF70741B73C73A00F6F0A3 /* MD2OnContentChangeHandler.swift in Sources */,
				59CE10111B60D71400ACE1E7 /* MD2NumberRangeValidator.swift in Sources */,
				59CB70841B5EB321001D312F /* MD2Enum.swift in Sources */,
				59C3D5E01B698C9900C5A613 /* MD2OnClickHandler.swift in Sources */,
				59C3D5D61B6966C000C5A613 /* MD2TextFieldWidget.swift in Sources */,
				59CE101D1B60E87300ACE1E7 /* MD2EventHandler.swift in Sources */,
				59CE10171B60DFAC00ACE1E7 /* MD2RegEx.swift in Sources */,
				59CE10211B60E8F500ACE1E7 /* MD2WidgetEventHandler.swift in Sources */,
				59C3D5F11B6FBF6C00C5A613 /* MD2DateTimePickerWidget.swift in Sources */,
				59CB70961B5FA283001D312F /* MD2Location.swift in Sources */,
				59C1EA2D1B7E45E3003DADDF /* MD2Event.swift in Sources */,
				59C3D5BD1B67FDFB00C5A613 /* MD2ViewManager.swift in Sources */,
				59CB707E1B5EAE2D001D312F /* MD2Type.swift in Sources */,
				59CE101B1B60E35500ACE1E7 /* MD2DateTimeValidator.swift in Sources */,
				59C3D5EB1B6F84EA00C5A613 /* MD2SpacerWidget.swift in Sources */,
				595E26E21B7D135D004F484A /* MD2WorkflowEventHandler.swift in Sources */,
				59C3D5D41B69260D00C5A613 /* MD2ButtonWidget.swift in Sources */,
				59CB70B71B60CDE6001D312F /* MD2StringRangeValidator.swift in Sources */,
				59DF70601B726AE600F6F0A3 /* MD2WebServiceCallAction.swift in Sources */,
				59FA448A1B8F54AE0000CF02 /* MD2RemoteStore.swift in Sources */,
				59C3D5D21B691FC100C5A613 /* MD2LabelWidget.swift in Sources */,
				59CB70A81B5FDD37001D312F /* MD2Controller.swift in Sources */,
				59D0070A1B6FCFFA00FA922D /* MD2UIColorExtension.swift in Sources */,
				59CE10151B60DD5800ACE1E7 /* MD2RegExValidator.swift in Sources */,
				59C3D5BF1B6802DB00C5A613 /* MD2Layout.swift in Sources */,
				59DF70521B7265CC00F6F0A3 /* MD2OnConnectionRegainedHandler.swift in Sources */,
				59DF70641B726EB300F6F0A3 /* MD2OnWrongValidationHandler.swift in Sources */,
				59C3D5BB1B67FC0C00C5A613 /* MD2WidgetRegistry.swift in Sources */,
				59C3D5ED1B6FAB4B00C5A613 /* MD2GridLayoutPane.swift in Sources */,
				59C6A0D61B7BA54B0038E056 /* MD2UpdateContentProviderAction.swift in Sources */,
				59CB709A1B5FB6E5001D312F /* MD2DataStore.swift in Sources */,
				59FA44841B8F41640000CF02 /* MD2RestClient.swift in Sources */,
				59DF704A1B72643900F6F0A3 /* MD2SetWorkflowElementAction.swift in Sources */,
				59DF706A1B72711100F6F0A3 /* MD2TemporalType.swift in Sources */,
				59CB70921B5F9932001D312F /* MD2DateTime.swift in Sources */,
				59CB70B51B5FE4C3001D312F /* MD2NotNullValidator.swift in Sources */,
				59D007061B6FCE5400FA922D /* MD2WidgetTextStyle.swift in Sources */,
				59CB708A1B5EB78D001D312F /* MD2Integer.swift in Sources */,
				59CB70A41B5FBC6A001D312F /* MD2LocalStore.swift in Sources */,
				59C3D5C31B680E4400C5A613 /* MD2FlowLayoutPane.swift in Sources */,
				59CB70801B5EB15C001D312F /* MD2DataType.swift in Sources */,
				59CE10251B60E9EA00ACE1E7 /* MD2OnWidgetChangeHandler.swift in Sources */,
				595E26E81B7D197C004F484A /* MD2WorkflowAction.swift in Sources */,
				59CB70881B5EB72B001D312F /* MD2Boolean.swift in Sources */,
				59CB708C1B5F8E23001D312F /* MD2Float.swift in Sources */,
				59CE101F1B60E89000ACE1E7 /* MD2GlobalEventHandler.swift in Sources */,
				59DF705E1B726A6900F6F0A3 /* MD2FireEventAction.swift in Sources */,
				59DF70481B7260FB00F6F0A3 /* MD2AssignObjectAction.swift in Sources */,
				59CB70821B5EB281001D312F /* MD2NumericType.swift in Sources */,
				59C3D5E91B6F840300C5A613 /* MD2ViewConfig.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
		59CD55B11B5E8259007B9834 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				59CD55BC1B5E8259007B9834 /* «Settings.XCODE_TARGET_TEST».swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin PBXTargetDependency section */
		59CD55B71B5E8259007B9834 /* PBXTargetDependency */ = {
			isa = PBXTargetDependency;
			target = «IOSGeneratorUtil.getUuid(Settings.XCODE_TARGET_APP + "__target")» /* «Settings.XCODE_TARGET_APP» */;
			targetProxy = 59CD55B61B5E8259007B9834 /* PBXContainerItemProxy */;
		};
/* End PBXTargetDependency section */

/* Begin XCBuildConfiguration section */
		59CD55BD1B5E8259007B9834 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++0x";
				CLANG_CXX_LIBRARY = "libc++";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "iPhone Developer";
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				GCC_C_LANGUAGE_STANDARD = gnu99;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				GCC_SYMBOLS_PRIVATE_EXTERN = NO;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 8.3;
				MTL_ENABLE_DEBUG_INFO = YES;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Debug;
		};
		59CD55BE1B5E8259007B9834 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++0x";
				CLANG_CXX_LIBRARY = "libc++";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "iPhone Developer";
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				GCC_C_LANGUAGE_STANDARD = gnu99;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 8.3;
				MTL_ENABLE_DEBUG_INFO = NO;
				SDKROOT = iphoneos;
				TARGETED_DEVICE_FAMILY = "1,2";
				VALIDATE_PRODUCT = YES;
			};
			name = Release;
		};
		59CD55C01B5E8259007B9834 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				INFOPLIST_FILE = "«Settings.XCODE_TARGET_APP»/Info.plist";
				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks";
				PRODUCT_NAME = "$(TARGET_NAME)";
			};
			name = Debug;
		};
		59CD55C11B5E8259007B9834 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				INFOPLIST_FILE = "«Settings.XCODE_TARGET_APP»/Info.plist";
				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks";
				PRODUCT_NAME = "$(TARGET_NAME)";
			};
			name = Release;
		};
		59CD55C31B5E8259007B9834 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				BUNDLE_LOADER = "$(TEST_HOST)";
				FRAMEWORK_SEARCH_PATHS = (
					"$(SDKROOT)/Developer/Library/Frameworks",
					"$(inherited)",
				);
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				INFOPLIST_FILE = "«Settings.XCODE_TARGET_TEST»/Info.plist";
				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks @loader_path/Frameworks";
				PRODUCT_NAME = "$(TARGET_NAME)";
				TEST_HOST = "$(BUILT_PRODUCTS_DIR)/«Settings.APP_NAME».app/«Settings.APP_NAME»";
			};
			name = Debug;
		};
		59CD55C41B5E8259007B9834 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				BUNDLE_LOADER = "$(TEST_HOST)";
				FRAMEWORK_SEARCH_PATHS = (
					"$(SDKROOT)/Developer/Library/Frameworks",
					"$(inherited)",
				);
				INFOPLIST_FILE = "«Settings.XCODE_TARGET_TEST»/Info.plist";
				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks @loader_path/Frameworks";
				PRODUCT_NAME = "$(TARGET_NAME)";
				TEST_HOST = "$(BUILT_PRODUCTS_DIR)/«Settings.APP_NAME».app/«Settings.APP_NAME»";
			};
			name = Release;
		};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		59CD559B1B5E8258007B9834 /* Build configuration list for PBXProject "«Settings.APP_NAME»" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				59CD55BD1B5E8259007B9834 /* Debug */,
				59CD55BE1B5E8259007B9834 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		59CD55BF1B5E8259007B9834 /* Build configuration list for PBXNativeTarget "«Settings.XCODE_TARGET_APP»" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				59CD55C01B5E8259007B9834 /* Debug */,
				59CD55C11B5E8259007B9834 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		59CD55C21B5E8259007B9834 /* Build configuration list for PBXNativeTarget "«Settings.XCODE_TARGET_TEST»" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				59CD55C31B5E8259007B9834 /* Debug */,
				59CD55C41B5E8259007B9834 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */

/* Begin XCVersionGroup section */
		59D363E51B77AAB200E51E19 /* LocalData.xcdatamodeld */ = {
			isa = XCVersionGroup;
			children = (
				59D363E61B77AAB300E51E19 /* LocalData.xcdatamodel */,
			);
			currentVersion = 59D363E61B77AAB300E51E19 /* LocalData.xcdatamodel */;
			path = LocalData.xcdatamodeld;
			sourceTree = "<group>";
			versionGroupType = wrapper.xcdatamodel;
		};
/* End XCVersionGroup section */
	};
	rootObject = 59CD55981B5E8258007B9834 /* Project object */;
}
	'''
	
}