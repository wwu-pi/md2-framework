package de.wwu.md2.framework.generator.android.wearable.util

import com.google.common.base.Joiner
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.SimpleType
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import de.wwu.md2.framework.generator.android.wearable.Settings

class MD2AndroidWearableUtil {
	
	/**
	 * Returns the package name that is being derived from the String path
	 */
	def static String getPackageNameFromPath(String path) {
		val joiner = Joiner.on(".")
		val pathSegments = path.split("/").map([s | s.toFirstLower])
		return joiner.join(pathSegments)
	}
	
	def static String getTypeNameForContentProvider(ContentProvider cp){
		val type = cp.type
		
		switch type{
			ReferencedModelType: return type.entity.name.toFirstUpper
			SimpleType: return "Md2" + type.type.getName.toFirstUpper
		}
	}
	
	def static getQualifiedName(EObject obj){
		val qualifiedNameProvider = new DefaultDeclarativeQualifiedNameProvider
		qualifiedNameProvider.getFullyQualifiedName(obj)
	}
	
	def static getQualifiedNameAsString(EObject obj, String delimiter){
		val qualifiedNameProvider = new DefaultDeclarativeQualifiedNameProvider
		var qualifiedName = qualifiedNameProvider.getFullyQualifiedName(obj)
		if(qualifiedName != null)
			return qualifiedName.toString(delimiter)
		return ""
	}
	
	//TODO: These methods simply add all possible imports. It is not really a problem as Android Studio
	//		can automatically optimize imports for a whole project, but could be optimized anyway.	
	
	def static String generateImportAllWidgets()'''
		import «Settings.MD2LIBRARY_PACKAGE»view.widgets.implementation.Md2GridLayoutPane;
		import «Settings.MD2LIBRARY_PACKAGE»view.widgets.implementation.Md2FlowLayoutPane;
		import «Settings.MD2LIBRARY_PACKAGE»view.widgets.implementation.Md2Label;
		import «Settings.MD2LIBRARY_PACKAGE»view.widgets.implementation.Md2Button;
		import «Settings.MD2LIBRARY_PACKAGE»view.widgets.implementation.Md2TextInput;
	'''
	
	def static String generateImportAllTypes()'''
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.Md2Boolean;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.Md2Date;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.Md2DateTime;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.Md2Float;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.Md2Integer;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.Md2String;
		import «Settings.MD2LIBRARY_PACKAGE»model.type.implementation.Md2Time;
	'''
	
	def static String generateImportAllActions()'''
		import «Settings.MD2LIBRARY_PACKAGE»controller.action.implementation.AbstractMd2Action;
		import «Settings.MD2LIBRARY_PACKAGE»controller.action.implementation.Md2ContentProviderOperationAction;
		import «Settings.MD2LIBRARY_PACKAGE»controller.action.implementation.Md2ContentProviderOperations;
		import «Settings.MD2LIBRARY_PACKAGE»controller.action.implementation.Md2ContentProviderResetAction;
		import «Settings.MD2LIBRARY_PACKAGE»controller.action.implementation.Md2DisplayMessageAction;
		import «Settings.MD2LIBRARY_PACKAGE»controller.action.implementation.Md2FireEventAction;
		import «Settings.MD2LIBRARY_PACKAGE»controller.action.implementation.Md2GoToViewAction;
		import «Settings.MD2LIBRARY_PACKAGE»controller.action.implementation.Md2SynchronizeContentProviderDataMappingAction;
		import «Settings.MD2LIBRARY_PACKAGE»controller.action.implementation.Md2SynchronizeWidgetDataMappingAction;
		import «Settings.MD2LIBRARY_PACKAGE»controller.action.interfaces.Md2Action;
		
	'''
	
	def static String generateImportAllEventHandler()'''
		import «Settings.MD2LIBRARY_PACKAGE»controller.eventhandler.implementation.Md2ContentProviderEventTypes;
		import «Settings.MD2LIBRARY_PACKAGE»controller.eventhandler.implementation.Md2OnAttributeChangedHandler;
		import «Settings.MD2LIBRARY_PACKAGE»controller.eventhandler.implementation.Md2OnChangedHandler;
		import «Settings.MD2LIBRARY_PACKAGE»controller.eventhandler.implementation.Md2OnClickHandler;
		import «Settings.MD2LIBRARY_PACKAGE»controller.eventhandler.implementation.Md2OnLeftSwipeHandler;
		import «Settings.MD2LIBRARY_PACKAGE»controller.eventhandler.implementation.Md2OnRightSwipeHandler;
		import «Settings.MD2LIBRARY_PACKAGE»controller.eventhandler.implementation.Md2WidgetEventType;
	'''
	
	def static String generateImportAllExceptions()'''
		import «Settings.MD2LIBRARY_PACKAGE»exception.Md2WidgetNotCreatedException;
	'''
	
	def static String generateImportAllCustomCodeTasks()'''
		import «Settings.MD2LIBRARY_PACKAGE»controller.action.implementation.customCode.interfaces.Md2CustomCodeTask;
		import «Settings.MD2LIBRARY_PACKAGE»controller.action.implementation.customCode.Md2AttributeSetTask;
		import «Settings.MD2LIBRARY_PACKAGE»controller.action.implementation.customCode.Md2BindTask;
		import «Settings.MD2LIBRARY_PACKAGE»controller.action.implementation.customCode.Md2CallTask;
		import «Settings.MD2LIBRARY_PACKAGE»controller.action.implementation.customCode.Md2MapTask;
		import «Settings.MD2LIBRARY_PACKAGE»controller.action.implementation.customCode.Md2UnbindTask;
		import «Settings.MD2LIBRARY_PACKAGE»controller.action.implementation.customCode.Md2UnmapTask;
	'''
}
