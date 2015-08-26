package de.wwu.md2.framework.generator.android.lollipop.util

import com.google.common.base.Joiner
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.SimpleType
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import org.eclipse.emf.ecore.EObject

class MD2AndroidLollipopUtil {
	
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
	
	def static String generateImportAllWidgets()'''
		import de.uni_muenster.wi.fabian.md2library.view.widgets.implementation.Md2GridLayoutPane;
		import de.uni_muenster.wi.fabian.md2library.view.widgets.implementation.Md2FlowLayoutPane;
		import de.uni_muenster.wi.fabian.md2library.view.widgets.implementation.Md2Label;
		import de.uni_muenster.wi.fabian.md2library.view.widgets.implementation.Md2Button;
		import de.uni_muenster.wi.fabian.md2library.view.widgets.implementation.Md2TextInput;
	'''
	
	def static String generateImportAllTypes()'''
		import de.uni_muenster.wi.fabian.md2library.model.type.implementation.Md2Boolean;
		import de.uni_muenster.wi.fabian.md2library.model.type.implementation.Md2Date;
		import de.uni_muenster.wi.fabian.md2library.model.type.implementation.Md2DateTime;
		import de.uni_muenster.wi.fabian.md2library.model.type.implementation.Md2Float;
		import de.uni_muenster.wi.fabian.md2library.model.type.implementation.Md2Integer;
		import de.uni_muenster.wi.fabian.md2library.model.type.implementation.Md2String;
		import de.uni_muenster.wi.fabian.md2library.model.type.implementation.Md2Time;
	'''
	
	def static String generateImportAllEventHandler()'''
		import de.uni_muenster.wi.fabian.md2library.controller.action.implementation.AbstractMd2Action;
		import de.uni_muenster.wi.fabian.md2library.controller.action.implementation.Md2ContentProivderOperationAction;
		import de.uni_muenster.wi.fabian.md2library.controller.action.implementation.Md2ContentProviderOperations;
		import de.uni_muenster.wi.fabian.md2library.controller.action.implementation.Md2ContentProviderResetAction;
		import de.uni_muenster.wi.fabian.md2library.controller.action.implementation.Md2DisplayMessageAction;
		import de.uni_muenster.wi.fabian.md2library.controller.action.implementation.Md2FireEventAction;
		import de.uni_muenster.wi.fabian.md2library.controller.action.implementation.Md2GoToViewAction;
		import de.uni_muenster.wi.fabian.md2library.controller.action.implementation.Md2SynchronizeContentProviderDataMapping;
		import de.uni_muenster.wi.fabian.md2library.controller.action.implementation.Md2SynchronizeWidgetDataMappingAction;
		import de.uni_muenster.wi.fabian.md2library.controller.action.interfaces.Md2Action;
		
	'''
	
	def static String generateImportAllActions()'''
		import de.uni_muenster.wi.fabian.md2library.controller.eventhandler.implementation.Md2ContentProviderEventTypes;
		import de.uni_muenster.wi.fabian.md2library.controller.eventhandler.implementation.Md2OnAttributeChangedHandlerHandler;
		import de.uni_muenster.wi.fabian.md2library.controller.eventhandler.implementation.Md2OnChangedHandler;
		import de.uni_muenster.wi.fabian.md2library.controller.eventhandler.implementation.Md2OnClickHandler;
		import de.uni_muenster.wi.fabian.md2library.controller.eventhandler.implementation.Md2OnLeftSwipeHandler;
		import de.uni_muenster.wi.fabian.md2library.controller.eventhandler.implementation.Md2OnRightSwipeHandler;
		import de.uni_muenster.wi.fabian.md2library.controller.eventhandler.implementation.Md2WidgetEventType;
	'''
	
	def static String generateImportAllExceptions()'''
		import de.uni_muenster.wi.fabian.md2library.exception.WidgetNotCreatedException;
	'''
	
	def static String generateImportAllCustomActions()'''
		de.uni_muenster.wi.fabian.md2library.controller.action.implementation.customCode.interfaces.Md2CustomCodeAction;
		de.uni_muenster.wi.fabian.md2library.controller.action.implementation.customCode.Md2AttributeSetAction;
		de.uni_muenster.wi.fabian.md2library.controller.action.implementation.customCode.Md2BindAction;
		de.uni_muenster.wi.fabian.md2library.controller.action.implementation.customCode.Md2CallAction;
		de.uni_muenster.wi.fabian.md2library.controller.action.implementation.customCode.Md2MapAction;
		de.uni_muenster.wi.fabian.md2library.controller.action.implementation.customCode.Md2UnbindAction;
		de.uni_muenster.wi.fabian.md2library.controller.action.implementation.customCode.Md2UnmapAction;
	'''
}