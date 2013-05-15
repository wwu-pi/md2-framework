package de.wwu.md2.framework.generator.ios

import de.wwu.md2.framework.util.UuidProvider

class ProjectFile {
	
	def static generateProjectFile(UuidProvider uuidProvider, FileStructure fileStructure, String appName) '''
		// !$*UTF8*$!
		{
			archiveVersion = 1;
			classes = {
			};
			objectVersion = 46;
			objects = {
		
		«generatePBXBuildFileSection(uuidProvider, fileStructure)»
		
		«generatePBXFileReferenceSection(uuidProvider, fileStructure, appName)»
		
		«generatePBXFrameworksBuildPhaseSection(uuidProvider, fileStructure)»
		
		«generatePBXGroupSection(uuidProvider, fileStructure, appName)»
		
		«generatePBXNativeTargetSection(uuidProvider, appName)»
		
		«generatePBXProjectSection(uuidProvider, fileStructure, appName)»
		
		«generatePBXResourcesBuildPhaseSection(uuidProvider, fileStructure)»
		
		«generatePBXSourcesBuildPhaseSection(uuidProvider, fileStructure)»
		
		«generateXCBuildConfigurationSection(uuidProvider, fileStructure, appName)»
		
		«generateXCConfigurationListSection(uuidProvider, appName)»
		
		«generateXCVersionGroupSection(uuidProvider)»
			};
			rootObject = «uuidProvider.getUuid("ProjectObject")» /* Project object */;
		}
	'''
	
	def static generatePBXBuildFileSection(UuidProvider uuidProvider, FileStructure fileStructure) '''
		/* Begin PBXBuildFile section */
				«FOR curFile : fileStructure.getSourceFilesToBuild(false)»
					«uuidProvider.getUuid(curFile + "_BuildFile")» /* «curFile» in Sources */ = {isa = PBXBuildFile; fileRef = «uuidProvider.getUuid(curFile + "_FileReference")» /* «curFile» */; };
				«ENDFOR»
				«uuidProvider.getUuid("DataModel.xcdatamodeld_BuildFile")» /* DataModel.xcdatamodeld in Sources */ = {isa = PBXBuildFile; fileRef = «uuidProvider.getUuid("DataModel.xcdatamodeld_FileReference_to_build")» /* DataModel.xcdatamodeld */; };
		/* End PBXBuildFile section */
	'''
	
	def static generatePBXFileReferenceSection(UuidProvider uuidProvider, FileStructure fileStructure, String appName) '''
		/* Begin PBXFileReference section */
				«uuidProvider.getUuid(appName + ".app_FileReference")» /* «appName».app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = «appName».app; sourceTree = BUILT_PRODUCTS_DIR; };
				«FOR curFile : fileStructure.projectCodeFiles»
					«uuidProvider.getUuid(curFile + "_FileReference")» /* «curFile» */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = «IF curFile.endsWith(".h")»sourcecode.c.h«ELSEIF curFile.endsWith(".m")»sourcecode.c.objc«ENDIF»; path = «curFile»; sourceTree = "<group>"; };
				«ENDFOR»
				«FOR curFrameworkEntry : fileStructure.Frameworks.entrySet»
					«uuidProvider.getUuid(curFrameworkEntry.key + "_FileReference")» /* «curFrameworkEntry.key» */ = {isa = PBXFileReference; lastKnownFileType = wrapper.framework; name = «curFrameworkEntry.key»; path = «curFrameworkEntry.value»; sourceTree = SDKROOT; };
				«ENDFOR»
				«FOR curLocFile : fileStructure.LocalizableStrings»
					«uuidProvider.getUuid(curLocFile + "_FileReference")» /* «curLocFile» */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = text.plist.strings; path = «curLocFile»; sourceTree = "<group>"; };
				«ENDFOR»
				«uuidProvider.getUuid(fileStructure.PrefixHeader + "_FileReference")» /* «fileStructure.PrefixHeader» */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.c.h; path = "«fileStructure.PrefixHeader»"; sourceTree = "<group>"; };
				«FOR curImage : fileStructure.Images»
					«uuidProvider.getUuid(curImage + "_FileReference")» /* «curImage» */ = {isa = PBXFileReference; lastKnownFileType = image.png; path = «curImage»; sourceTree = "<group>"; };
				«ENDFOR»
				«uuidProvider.getUuid("DataModel.xcdatamodeld_FileReference")» /* DataModel.xcdatamodel */ = {isa = PBXFileReference; lastKnownFileType = wrapper.xcdatamodel; path = DataModel.xcdatamodel; sourceTree = "<group>"; };
		/* End PBXFileReference section */
	'''
	
	def static generatePBXFrameworksBuildPhaseSection(UuidProvider uuidProvider, FileStructure fileStructure) '''
		/* Begin PBXFrameworksBuildPhase section */
				«uuidProvider.getUuid("FrameworksBuildPhase")» /* Frameworks */ = {
					isa = PBXFrameworksBuildPhase;
					buildActionMask = 2147483647;
					files = (
						«FOR framework : fileStructure.Frameworks.keySet»
							«uuidProvider.getUuid(framework + "_BuildFile")» /* «framework» in Frameworks */,
						«ENDFOR»
					);
					runOnlyForDeploymentPostprocessing = 0;
				};
		/* End PBXFrameworksBuildPhase section */
	'''
	
	def static generatePBXGroupSection(UuidProvider uuidProvider, FileStructure fileStructure, String appName) '''
		/* Begin PBXGroup section */
				«FOR group : fileStructure.FolderStructure.entrySet»
					«uuidProvider.getUuid(group.key + "_FileReference")» «IF !group.key.equals(fileStructure.RootGroupName)»/* «group.key» */ «ENDIF»= {
						isa = PBXGroup;
						children = (
							«FOR fileName : group.value»
								«uuidProvider.getUuid(fileName + "_FileReference")» /* «fileName» */,
							«ENDFOR»
							«IF group.key.equals(fileStructure.DataModelFileFolder)»
								«uuidProvider.getUuid("DataModel.xcdatamodeld_FileReference_to_build")» /* DataModel.xcdatamodeld */,
							«ENDIF»
						);
						«IF group.key.equals(appName)»path = «appName»;«ELSEIF !group.key.equals(fileStructure.RootGroupName)»name = «group.key»;«ENDIF»
						sourceTree = "<group>";
					};
				«ENDFOR»
		/* End PBXGroup section */
	'''
	
	def static generatePBXNativeTargetSection(UuidProvider uuidProvider, String appName) '''
		/* Begin PBXNativeTarget section */
				«uuidProvider.getUuid("NativeTarget")» /* «appName» */ = {
					isa = PBXNativeTarget;
					buildConfigurationList = «uuidProvider.getUuid("NativeTargetBuildConfigurationList")» /* Build configuration list for PBXNativeTarget "«appName»" */;
					buildPhases = (
						«uuidProvider.getUuid("SourcesBuildPhase")» /* Sources */,
						«uuidProvider.getUuid("FrameworksBuildPhase")» /* Frameworks */,
						«uuidProvider.getUuid("ResourcesBuildPhase")» /* Resources */,
					);
					buildRules = (
					);
					dependencies = (
					);
					name = «appName»;
					productName = «appName»;
					productReference = «uuidProvider.getUuid(appName + ".app_FileReference")» /* «appName».app */;
					productType = "com.apple.product-type.application";
				};
		/* End PBXNativeTarget section */
	'''
	
	def static generatePBXProjectSection(UuidProvider uuidProvider, FileStructure fileStructure, String appName) '''
		/* Begin PBXProject section */
				«uuidProvider.getUuid("ProjectObject")» /* Project object */ = {
					isa = PBXProject;
					attributes = {
						LastUpgradeCheck = 0430;
					};
					buildConfigurationList = «uuidProvider.getUuid("ProjectBuildConfigurationList")» /* Build configuration list for PBXProject "«appName»" */;
					compatibilityVersion = "Xcode 3.2";
					developmentRegion = English;
					hasScannedForEncodings = 0;
					knownRegions = (
						en,
					);
					mainGroup = «uuidProvider.getUuid(fileStructure.RootGroupName + "_FileReference")»;
					productRefGroup = «uuidProvider.getUuid(fileStructure.ProductsGroupName + "_FileReference")» /* «fileStructure.ProductsGroupName» */;
					projectDirPath = "";
					projectRoot = "";
					targets = (
						«uuidProvider.getUuid("NativeTarget")» /* «appName» */,
					);
				};
		/* End PBXProject section */
	'''
	
	def static generatePBXResourcesBuildPhaseSection(UuidProvider uuidProvider, FileStructure fileStructure) '''
		/* Begin PBXResourcesBuildPhase section */
				«uuidProvider.getUuid("ResourcesBuildPhase")» /* Resources */ = {
					isa = PBXResourcesBuildPhase;
					buildActionMask = 2147483647;
					files = (
						«FOR currentResource : fileStructure.Images»
							«uuidProvider.getUuid(currentResource + "_BuildFile")» /* «currentResource» in Resources */,
						«ENDFOR»
						«FOR currentLoc : fileStructure.LocalizableStrings»
							«uuidProvider.getUuid(currentLoc + "_BuildFile")» /* «currentLoc» in Resources */,
						«ENDFOR»
					);
					runOnlyForDeploymentPostprocessing = 0;
				};
		/* End PBXResourcesBuildPhase section */
	'''
	
	def static generatePBXSourcesBuildPhaseSection(UuidProvider uuidProvider, FileStructure fileStructure) '''
		/* Begin PBXSourcesBuildPhase section */
				«uuidProvider.getUuid("SourcesBuildPhase")» /* Sources */ = {
					isa = PBXSourcesBuildPhase;
					buildActionMask = 2147483647;
					files = (
						«FOR curFile : fileStructure.getSourceFilesToBuild(true)»
							«uuidProvider.getUuid(curFile + "_BuildFile")» /* «curFile» in Sources */,
						«ENDFOR»
						«uuidProvider.getUuid("DataModel.xcdatamodeld_BuildFile")» /* DataModel.xcdatamodeld in Sources */,
					);
					runOnlyForDeploymentPostprocessing = 0;
				};
		/* End PBXSourcesBuildPhase section */
	'''
	
	def static generateXCBuildConfigurationSection(UuidProvider uuidProvider, FileStructure fileStructure, String appName) '''
		/* Begin XCBuildConfiguration section */
				«uuidProvider.getUuid("BuildConfigurationDebugiPhone")» /* Debug */ = {
					isa = XCBuildConfiguration;
					buildSettings = {
						ALWAYS_SEARCH_USER_PATHS = NO;
						ARCHS = "$(ARCHS_STANDARD_32_BIT)";
						CLANG_ENABLE_OBJC_ARC = YES;
						"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "iPhone Developer";
						COPY_PHASE_STRIP = NO;
						GCC_C_LANGUAGE_STANDARD = gnu99;
						GCC_DYNAMIC_NO_PIC = NO;
						GCC_OPTIMIZATION_LEVEL = 0;
						GCC_PREPROCESSOR_DEFINITIONS = (
							"DEBUG=1",
							"$(inherited)",
						);
						GCC_SYMBOLS_PRIVATE_EXTERN = NO;
						GCC_VERSION = com.apple.compilers.llvm.clang.1_0;
						GCC_WARN_ABOUT_RETURN_TYPE = YES;
						GCC_WARN_UNINITIALIZED_AUTOS = YES;
						GCC_WARN_UNUSED_VARIABLE = YES;
						MOMC_NO_INVERSE_RELATIONSHIP_WARNINGS = YES;
						IPHONEOS_DEPLOYMENT_TARGET = 5.1;
						SDKROOT = iphoneos;
						TARGETED_DEVICE_FAMILY = "1,2";
					};
					name = Debug;
				};
				«uuidProvider.getUuid("BuildConfigurationReleaseiPhone")» /* Release */ = {
					isa = XCBuildConfiguration;
					buildSettings = {
						ALWAYS_SEARCH_USER_PATHS = NO;
						ARCHS = "$(ARCHS_STANDARD_32_BIT)";
						CLANG_ENABLE_OBJC_ARC = YES;
						"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "iPhone Developer";
						COPY_PHASE_STRIP = YES;
						GCC_C_LANGUAGE_STANDARD = gnu99;
						GCC_VERSION = com.apple.compilers.llvm.clang.1_0;
						GCC_WARN_ABOUT_RETURN_TYPE = YES;
						GCC_WARN_UNINITIALIZED_AUTOS = YES;
						GCC_WARN_UNUSED_VARIABLE = YES;
						MOMC_NO_INVERSE_RELATIONSHIP_WARNINGS = YES;
						IPHONEOS_DEPLOYMENT_TARGET = 5.1;
						OTHER_CFLAGS = "-DNS_BLOCK_ASSERTIONS=1";
						SDKROOT = iphoneos;
						TARGETED_DEVICE_FAMILY = "1,2";
						VALIDATE_PRODUCT = YES;
					};
					name = Release;
				};
				«uuidProvider.getUuid("BuildConfigurationDebugiPad")» /* Debug */ = {
					isa = XCBuildConfiguration;
					buildSettings = {
						CLANG_ENABLE_OBJC_ARC = YES;
						GCC_PRECOMPILE_PREFIX_HEADER = YES;
						GCC_PREFIX_HEADER = "«appName»/«fileStructure.PrefixHeader»";
						MOMC_NO_INVERSE_RELATIONSHIP_WARNINGS = YES;
						INFOPLIST_FILE = "«appName»/«fileStructure.InfoFile»";
						LIBRARY_SEARCH_PATHS = (
							"$(inherited)",
							"\"$(SRCROOT)/«appName»\"",
						);
						PRODUCT_NAME = "$(TARGET_NAME)";
						WRAPPER_EXTENSION = app;
					};
					name = Debug;
				};
				«uuidProvider.getUuid("BuildConfigurationReleaseiPad")» /* Release */ = {
					isa = XCBuildConfiguration;
					buildSettings = {
						GCC_PRECOMPILE_PREFIX_HEADER = YES;
						GCC_PREFIX_HEADER = "«appName»/«fileStructure.PrefixHeader»";
						MOMC_NO_INVERSE_RELATIONSHIP_WARNINGS = YES;
						INFOPLIST_FILE = "«appName»/«fileStructure.InfoFile»";
						LIBRARY_SEARCH_PATHS = (
							"$(inherited)",
							"\"$(SRCROOT)/«appName»\"",
						);
						PRODUCT_NAME = "$(TARGET_NAME)";
						WRAPPER_EXTENSION = app;
					};
					name = Release;
				};
		/* End XCBuildConfiguration section */
	'''
	
	def static generateXCConfigurationListSection(UuidProvider uuidProvider, String appName) '''
		/* Begin XCConfigurationList section */
				«uuidProvider.getUuid("ProjectBuildConfigurationList")» /* Build configuration list for PBXProject "«appName»" */ = {
					isa = XCConfigurationList;
					buildConfigurations = (
						«uuidProvider.getUuid("BuildConfigurationDebugiPhone")» /* Debug */,
						«uuidProvider.getUuid("BuildConfigurationReleaseiPhone")» /* Release */,
					);
					defaultConfigurationIsVisible = 0;
					defaultConfigurationName = Release;
				};
				«uuidProvider.getUuid("NativeTargetBuildConfigurationList")» /* Build configuration list for PBXNativeTarget "«appName»" */ = {
					isa = XCConfigurationList;
					buildConfigurations = (
						«uuidProvider.getUuid("BuildConfigurationDebugiPad")» /* Debug */,
						«uuidProvider.getUuid("BuildConfigurationReleaseiPad")» /* Release */,
					);
					defaultConfigurationIsVisible = 0;
					defaultConfigurationName = Release;
				};
		/* End XCConfigurationList section */
	'''
	
	def static generateXCVersionGroupSection(UuidProvider uuidProvider) '''
		/* Begin XCVersionGroup section */
				«uuidProvider.getUuid("DataModel.xcdatamodeld_FileReference_to_build")» /* DataModel.xcdatamodeld */ = {
					isa = XCVersionGroup;
					children = (
						«uuidProvider.getUuid("DataModel.xcdatamodeld_FileReference")» /* DataModel.xcdatamodel */,
					);
					currentVersion = «uuidProvider.getUuid("DataModel.xcdatamodeld_FileReference")» /* DataModel.xcdatamodel */;
					path = DataModel.xcdatamodeld;
					sourceTree = "<group>";
					versionGroupType = wrapper.xcdatamodel;
				};
		/* End XCVersionGroup section */
	'''
}
