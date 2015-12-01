package de.wwu.md2.framework.generator.ios

import de.wwu.md2.framework.util.UuidProvider

class ProjectFile {
	
	extension UuidProvider uuidProvider;
	
	static String md2LibraryName = IOSGenerator::md2LibraryName
	static String libMd2LibraryOutput = "libMd2Library.a"
	static String libMd2LibraryOutputId = "9C8E95D41746456D00C2C5BA"
	
	def generateProjectFile(UuidProvider uuidProvider, FileStructure fileStructure, String appName) {
		this.uuidProvider = uuidProvider
		doGenerateProjectFile(fileStructure, appName)
	}
	
	def protected doGenerateProjectFile(FileStructure fileStructure, String appName) '''
		// !$*UTF8*$!
		{
			archiveVersion = 1;
			classes = {
			};
			objectVersion = 46;
			objects = {
		
		«generatePBXBuildFileSection(uuidProvider, fileStructure)»
		
		«generatePBXContainerItemProxySection»
		
		«generatePBXFileReferenceSection(fileStructure, appName)»
		
		«generatePBXFrameworksBuildPhaseSection(fileStructure)»
		
		«generatePBXGroupSection(fileStructure, appName)»
		
		«generatePBXNativeTargetSection(uuidProvider, appName)»
		
		«generatePBXProjectSection(fileStructure, appName)»
		
		«generatePBXReferenceProxySection»
		
		«generatePBXResourcesBuildPhaseSection(uuidProvider, fileStructure)»
		
		«generatePBXSourcesBuildPhaseSection(uuidProvider, fileStructure)»
		
		«generateXCBuildConfigurationSection(uuidProvider, fileStructure, appName)»
		
		«generateXCConfigurationListSection(uuidProvider, appName)»
		
		«generateXCVersionGroupSection(uuidProvider)»
			};
			rootObject = «"ProjectObject".uuid» /* Project object */;
		}
	'''
	
	def static generatePBXBuildFileSection(UuidProvider uuidProvider, FileStructure fileStructure) {
		val lines = <String>newArrayList()
		lines += fileStructure.getSourceFilesToBuild(false).map[curFile | 
					'''«uuidProvider.getUuid(curFile + "_BuildFile")» /* «curFile» in Sources */ = {isa = PBXBuildFile; fileRef = «uuidProvider.getUuid(curFile + "_FileReference")» /* «curFile» */; };'''
				]
		lines +=	'''«uuidProvider.getUuid(libMd2LibraryOutput + "_BuildFile")» /* «libMd2LibraryOutput» in Frameworks */ = {isa = PBXBuildFile; fileRef = «uuidProvider.getUuid(libMd2LibraryOutput + "_ReferenceProxy")» /* «libMd2LibraryOutput» */; };'''
		lines +=	'''«uuidProvider.getUuid("DataModel.xcdatamodeld_BuildFile")» /* DataModel.xcdatamodeld in Sources */ = {isa = PBXBuildFile; fileRef = «uuidProvider.getUuid("DataModel.xcdatamodeld_FileReference_to_build")» /* DataModel.xcdatamodeld */; };'''
		'''
		/* Begin PBXBuildFile section */
				«FOR curLine : lines.sort»
					«curLine»
				«ENDFOR»
		/* End PBXBuildFile section */
		'''
	}
	
	def protected generatePBXContainerItemProxySection() '''
		/* Begin PBXContainerItemProxy section */
				«"ContainerItemProxy".uuid» /* PBXContainerItemProxy */ = {
					isa = PBXContainerItemProxy;
					containerPortal = «(md2LibraryName + ".xcodeproj_FileReference").uuid» /* «md2LibraryName».xcodeproj */;
					proxyType = 2;
«««refers to id of libMd2Library.a file reference in Md2Library project file»»»
					remoteGlobalIDString = «libMd2LibraryOutputId»;
					remoteInfo = «md2LibraryName»;
				};
		/* End PBXContainerItemProxy section */
	'''
	
	def protected generatePBXFileReferenceSection(FileStructure fileStructure, String appName) {
		val lines = <String>newArrayList()
		lines +=	'''«uuidProvider.getUuid(appName + ".app_FileReference")» /* «appName».app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = «appName».app; sourceTree = BUILT_PRODUCTS_DIR; };'''
		lines += fileStructure.projectCodeFiles.map[ curFile |
					'''«uuidProvider.getUuid(curFile + "_FileReference")» /* «curFile» */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = «IF curFile.endsWith(".h")»sourcecode.c.h«ELSEIF curFile.endsWith(".m")»sourcecode.c.objc«ENDIF»; path = «curFile»; sourceTree = "<group>"; };'''
				]
		lines += fileStructure.Frameworks.entrySet.map[ curFrameworkEntry |
					'''«uuidProvider.getUuid(curFrameworkEntry.key + "_FileReference")» /* «curFrameworkEntry.key» */ = {isa = PBXFileReference; lastKnownFileType = wrapper.framework; name = «curFrameworkEntry.key»; path = «curFrameworkEntry.value»; sourceTree = SDKROOT; };'''
				]
		lines += fileStructure.LocalizableStrings.map[ curLocFile |
					'''«uuidProvider.getUuid(curLocFile + "_FileReference")» /* «curLocFile» */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = text.plist.strings; path = «curLocFile»; sourceTree = "<group>"; };'''
				]
		lines +=	'''«uuidProvider.getUuid(fileStructure.PrefixHeader + "_FileReference")» /* «fileStructure.PrefixHeader» */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.c.h; path = "«fileStructure.PrefixHeader»"; sourceTree = "<group>"; };'''
		lines += fileStructure.Images.map[ curImage |
					'''«uuidProvider.getUuid(curImage + "_FileReference")» /* «curImage» */ = {isa = PBXFileReference; lastKnownFileType = image.png; path = «curImage»; sourceTree = "<group>"; };'''
				]
		lines += fileStructure.ImagesFromLibrary.map[ curLibImage |
					'''«uuidProvider.getUuid(curLibImage + "_FileReference")» /* «curLibImage» */ = {isa = PBXFileReference; lastKnownFileType = image.png; name = «curLibImage»; path = "../Md2Library/Md2Library/«curLibImage»"; sourceTree = "<group>"; };'''
				]
		lines +=	'''«(md2LibraryName+".xcodeproj_FileReference").uuid» /* «md2LibraryName».xcodeproj */ = {isa = PBXFileReference; lastKnownFileType = "wrapper.pb-project"; name = «md2LibraryName».xcodeproj; path = «md2LibraryName»/«md2LibraryName».xcodeproj; sourceTree = "<group>"; };'''
		lines +=	'''«uuidProvider.getUuid("DataModel.xcdatamodeld_FileReference")» /* DataModel.xcdatamodel */ = {isa = PBXFileReference; lastKnownFileType = wrapper.xcdatamodel; path = DataModel.xcdatamodel; sourceTree = "<group>"; };'''
		'''
		/* Begin PBXFileReference section */
				«FOR curLine : lines.sort»
					«curLine»
				«ENDFOR»
		/* End PBXFileReference section */
		'''
	}
	
	def protected generatePBXFrameworksBuildPhaseSection(FileStructure fileStructure) '''
		/* Begin PBXFrameworksBuildPhase section */
				«uuidProvider.getUuid("FrameworksBuildPhase")» /* Frameworks */ = {
					isa = PBXFrameworksBuildPhase;
					buildActionMask = 2147483647;
					files = (
						«(libMd2LibraryOutput + "_BuildFile").uuid» /* «libMd2LibraryOutput» in Frameworks */,
						«FOR framework : fileStructure.Frameworks.keySet»
							«uuidProvider.getUuid(framework + "_BuildFile")» /* «framework» in Frameworks */,
						«ENDFOR»
					);
					runOnlyForDeploymentPostprocessing = 0;
				};
		/* End PBXFrameworksBuildPhase section */
	'''
	
	def protected generatePBXGroupSection(FileStructure fileStructure, String appName) {
		val lines = <String>newArrayList()
		lines += fileStructure.FolderStructure.entrySet.map[ group | '''
					«uuidProvider.getUuid(group.key + "_FileReference")» «IF !group.key.equals(fileStructure.RootGroupName)»/* «group.key» */ «ENDIF»= {
						isa = PBXGroup;
						children = (
							«IF group.key.equals(fileStructure.RootGroupName)»
								«(md2LibraryName+".xcodeproj_FileReference").uuid» /* «md2LibraryName».xcodeproj */,
							«ENDIF»
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
				''']
		lines += '''
					«"Products_Group".uuid» /* Products */ = {
						isa = PBXGroup;
						children = (
							«(libMd2LibraryOutput + "_ReferenceProxy").uuid» /* «libMd2LibraryOutput» */,
						);
						name = Products;
						sourceTree = "<group>";
					};
				'''
		'''
		/* Begin PBXGroup section */
				«FOR curLine : lines.sort»
					«curLine»
				«ENDFOR»
		/* End PBXGroup section */
		'''
	}
	
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
	
	def protected generatePBXProjectSection(FileStructure fileStructure, String appName) '''
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
					projectReferences = (
						{
							ProductGroup = «"Products_Group".uuid» /* Products */;
							ProjectRef = «(md2LibraryName+".xcodeproj_FileReference").uuid» /* «md2LibraryName».xcodeproj */;
						},
					);
					projectRoot = "";
					targets = (
						«uuidProvider.getUuid("NativeTarget")» /* «appName» */,
					);
				};
		/* End PBXProject section */
	'''
	
	def protected generatePBXReferenceProxySection() '''
		/* Begin PBXReferenceProxy section */
				«(libMd2LibraryOutput + "_ReferenceProxy").uuid» /* «libMd2LibraryOutput» */ = {
					isa = PBXReferenceProxy;
					fileType = archive.ar;
					path = «libMd2LibraryOutput»;
					remoteRef = «"ContainerItemProxy".uuid» /* PBXContainerItemProxy */;
					sourceTree = BUILT_PRODUCTS_DIR;
				};
		/* End PBXReferenceProxy section */
	'''
	
	def static generatePBXResourcesBuildPhaseSection(UuidProvider uuidProvider, FileStructure fileStructure) '''
		/* Begin PBXResourcesBuildPhase section */
				«uuidProvider.getUuid("ResourcesBuildPhase")» /* Resources */ = {
					isa = PBXResourcesBuildPhase;
					buildActionMask = 2147483647;
					files = (
						«FOR currentResource : (fileStructure.Images+fileStructure.ImagesFromLibrary)»
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
	
	def static generateXCBuildConfigurationSection(UuidProvider uuidProvider, FileStructure fileStructure, String appName) {
		val lines = <String>newArrayList();
		lines += '''
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
							IPHONEOS_DEPLOYMENT_TARGET = 5.1;
							MOMC_NO_INVERSE_RELATIONSHIP_WARNINGS = YES;
							SDKROOT = iphoneos;
							TARGETED_DEVICE_FAMILY = "1,2";
						};
						name = Debug;
					};
				'''
		lines += '''
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
							IPHONEOS_DEPLOYMENT_TARGET = 5.1;
							MOMC_NO_INVERSE_RELATIONSHIP_WARNINGS = YES;
							OTHER_CFLAGS = "-DNS_BLOCK_ASSERTIONS=1";
							SDKROOT = iphoneos;
							TARGETED_DEVICE_FAMILY = "1,2";
							VALIDATE_PRODUCT = YES;
						};
						name = Release;
					};
				'''
		lines += '''
					«uuidProvider.getUuid("BuildConfigurationDebugiPad")» /* Debug */ = {
						isa = XCBuildConfiguration;
						buildSettings = {
							CLANG_ENABLE_OBJC_ARC = YES;
							GCC_PRECOMPILE_PREFIX_HEADER = YES;
							GCC_PREFIX_HEADER = "«appName»/«fileStructure.PrefixHeader»";
							INFOPLIST_FILE = "«appName»/«fileStructure.InfoFile»";
							LIBRARY_SEARCH_PATHS = (
								"$(inherited)",
								"\"$(SRCROOT)/«appName»\"",
							);
							MOMC_NO_INVERSE_RELATIONSHIP_WARNINGS = YES;
							OTHER_LDFLAGS = "-ObjC";
							PRODUCT_NAME = "$(TARGET_NAME)";
							WRAPPER_EXTENSION = app;
						};
						name = Debug;
					};
				'''
		lines += '''
					«uuidProvider.getUuid("BuildConfigurationReleaseiPad")» /* Release */ = {
						isa = XCBuildConfiguration;
						buildSettings = {
							GCC_PRECOMPILE_PREFIX_HEADER = YES;
							GCC_PREFIX_HEADER = "«appName»/«fileStructure.PrefixHeader»";
							INFOPLIST_FILE = "«appName»/«fileStructure.InfoFile»";
							LIBRARY_SEARCH_PATHS = (
								"$(inherited)",
								"\"$(SRCROOT)/«appName»\"",
							);
							MOMC_NO_INVERSE_RELATIONSHIP_WARNINGS = YES;
							OTHER_LDFLAGS = "-ObjC";
							PRODUCT_NAME = "$(TARGET_NAME)";
							WRAPPER_EXTENSION = app;
						};
						name = Release;
					};
				'''
		
		'''
		/* Begin XCBuildConfiguration section */
				«FOR curLine : lines.sort»
					«curLine»
				«ENDFOR»
		/* End XCBuildConfiguration section */
		'''
	}
	
	def static generateXCConfigurationListSection(UuidProvider uuidProvider, String appName) {
		val lines = <String>newArrayList()
		lines += '''
					«uuidProvider.getUuid("ProjectBuildConfigurationList")» /* Build configuration list for PBXProject "«appName»" */ = {
						isa = XCConfigurationList;
						buildConfigurations = (
							«uuidProvider.getUuid("BuildConfigurationDebugiPhone")» /* Debug */,
							«uuidProvider.getUuid("BuildConfigurationReleaseiPhone")» /* Release */,
						);
						defaultConfigurationIsVisible = 0;
						defaultConfigurationName = Release;
					};
				'''
		lines += '''
					«uuidProvider.getUuid("NativeTargetBuildConfigurationList")» /* Build configuration list for PBXNativeTarget "«appName»" */ = {
						isa = XCConfigurationList;
						buildConfigurations = (
							«uuidProvider.getUuid("BuildConfigurationDebugiPad")» /* Debug */,
							«uuidProvider.getUuid("BuildConfigurationReleaseiPad")» /* Release */,
						);
						defaultConfigurationIsVisible = 0;
						defaultConfigurationName = Release;
					};
				'''
		
		'''
		/* Begin XCConfigurationList section */
				«FOR curLine : lines.sort»
					«curLine»
				«ENDFOR»
		/* End XCConfigurationList section */
		'''
	}
	
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
