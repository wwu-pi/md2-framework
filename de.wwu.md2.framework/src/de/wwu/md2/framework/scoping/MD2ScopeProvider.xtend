/*
 * generated by Xtext 2.13.0
 */
package de.wwu.md2.framework.scoping

import com.google.common.collect.Sets
import com.google.inject.Inject
import de.wwu.md2.framework.mD2.AbstractViewGUIElementRef
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ContentContainer
import de.wwu.md2.framework.mD2.ContentElement
import de.wwu.md2.framework.mD2.ContentProviderPath
import de.wwu.md2.framework.mD2.Controller
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.EntityPath
import de.wwu.md2.framework.mD2.FireEventEntry
import de.wwu.md2.framework.mD2.MD2Package
import de.wwu.md2.framework.mD2.PathTail
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.ReferencedType
import de.wwu.md2.framework.mD2.SubViewContainer
import de.wwu.md2.framework.mD2.ViewGUIElementReference
import de.wwu.md2.framework.mD2.WorkflowElement
import de.wwu.md2.framework.mD2.WorkflowElementEntry
import de.wwu.md2.framework.mD2.impl.FireEventEntryImpl
import de.wwu.md2.framework.util.GetFiredEventsHelper
import java.util.Collection
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.Scopes

/**
 * This class contains custom scoping description.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#scoping
 * on how and when to use it.
 */
class MD2ScopeProvider extends AbstractMD2ScopeProvider {

//	@Inject
//	private QualifiedNameProvider qualifiedNameProvider;
//	
//	@Inject
//	private IQualifiedNameProvider qualifiedNameProvider;

	@Inject
	GetFiredEventsHelper helper;

	public static Collection<EClass> validContainerForAbstractViews = Sets.newHashSet(MD2Package.eINSTANCE.getMain(),
		MD2Package.eINSTANCE.getProcessChainStep(), MD2Package.eINSTANCE.getSimpleAction());

	def dispatch IScope getScope(FireEventEntry fireEventEntry, EReference eventRef) {
		if(eventRef == MD2Package.eINSTANCE.fireEventEntry_StartedWorkflowElement){
			val wfe = fireEventEntry.eContainer() as WorkflowElementEntry;
			val controller = wfe.workflowElement.eContainer as Controller
			
			return Scopes.scopeFor(controller.controllerElements.filter(WorkflowElement))
		} else {
			val wfe = fireEventEntry.eContainer() as WorkflowElementEntry;
		
			// Get set of all Workflow Events fired within the Workflow Element
			val firedEvents = helper.getFiredEvents(wfe.getWorkflowElement());
		
			// Remove those that are already handled in other FireEventEntries
			for (FireEventEntry otherFireEventEntry : wfe.getFiredEvents()) {
				// Really only consider others
				if (otherFireEventEntry != fireEventEntry) {
		
					// remove Entry:
					// requires access to implementation, because getEvent() causes
					// exceptions with cyclic references when trying to resolve the Workflow Event
					firedEvents.remove(
						(otherFireEventEntry as FireEventEntryImpl).basicGetEvent()
					);
				}
			}
		
			return Scopes.scopeFor(firedEvents);
		}
	}

	// Scoping for nested attributes
	def dispatch IScope getScope(PathTail pathTail, EReference attributeRef) {
		val resultSet = Sets.newHashSet();
		val parent = pathTail.eContainer();
		if (parent instanceof PathTail) {
			val aType = parent.getAttributeRef().getType();
			if (aType instanceof ReferencedType) {
				val modelElement = aType.getElement();
				if (modelElement instanceof Entity) {
					resultSet.addAll(modelElement.getAttributes());
				}
			}

		} else if (parent instanceof ContentProviderPath) {
			val dType = parent.getContentProviderRef().getType();
			if (dType instanceof ReferencedModelType) {
				val modelElement = dType.getEntity();
				if (modelElement instanceof Entity) {
					resultSet.addAll(modelElement.getAttributes());
				}
			}
		} else if (parent instanceof EntityPath) {
			resultSet.addAll(parent.getEntityRef().getAttributes());
		}

		return Scopes.scopeFor(resultSet);
	}

	// Scoping for entities that are proxies for auto-generated view elements
	def dispatch IScope getScope(AbstractViewGUIElementRef context, EReference entityRef) {
		if (context.eContainer() instanceof AbstractViewGUIElementRef) {
			// Obtain the type of the parent element
			val parent = context.eContainer() as AbstractViewGUIElementRef;
			if (isContentElement(parent)) {
				return IScope.NULLSCOPE;
			} else {
				val ContainerElement container = // Get the reference to the parent container
					if (parent.getRef() instanceof ViewGUIElementReference && (parent.getRef() as ViewGUIElementReference).getValue() instanceof ContainerElement) {
						(parent.getRef() as ViewGUIElementReference).getValue() as ContainerElement;
					} else if (parent.getRef() instanceof ContainerElement) {
						parent.getRef() as ContainerElement;
					}
				// May be null in case of linking errors - quit gracefully to avoid NullPointer below
				if (container === null)
					return IScope.NULLSCOPE;
				switch(container){
					ContentContainer: return Scopes.scopeFor(container.elements)
					SubViewContainer: return Scopes.scopeFor(container.elements)
				}
				
//				val scope = delegateGetScope(context, entityRef);
//				return new FilteringScope(scope, new Predicate<IEObjectDescription>() {
//					override public def boolean apply(IEObjectDescription input) {
//						if (isValidViewElement(context, input.getEObjectOrProxy())) {
//							val iter = container.eAllContents();
//							while (iter.hasNext()) {
//								val obj = iter.next();
//								val qualifiedName = qualifiedNameProvider.getFullyQualifiedName(obj);
//								if(qualifiedName !== null &&
//									qualifiedName.equals(input.getQualifiedName())) return true;
//							}
//						}
//						return false;
//					}
//				});
			}
		}
		// return delegateGetScope(context, entityRef);
		// Scoping for referenced (to be copied) view elements - 2. level
//		val resultSet = Sets.newHashSet();
//		if (context.getRef() instanceof AutoGeneratedContentElement && !isRestrictedToContainer(context)) {
//			for (ContentProviderReference ref : (context.getRef() as AutoGeneratedContentElement).
//				getContentProvider()) {
//				val cp = ref.getContentProvider();
//				if (cp.getType() instanceof ReferencedModelType) {
//					val m = (cp.getType() as ReferencedModelType).getEntity();
//					if (m instanceof Entity) {
//						resultSet.add(m);
//					}
//				}
//			}
//
//			return Scopes.scopeFor(resultSet)
//		}
		
		// Else Top Level elements
		return super.getScope(context, entityRef);
		
//		// Scoping for referenced (to be copied) view elements
//		return new FilteringScope(Scopes.scopeFor(resultSet), new Predicate<IEObjectDescription>() {
//			override public def boolean apply(IEObjectDescription input) {
//				return isValidViewElement(context, input.getEObjectOrProxy());
//			}
//		});
	}

	def dispatch IScope getScope(EObject context, EReference ref) {
		// Fallback to regular scope
		return super.getScope(context, ref);
	}

	private static def boolean isContentElement(AbstractViewGUIElementRef abtractRef) {
		var objInQuestion = abtractRef.getRef();
		if (abtractRef.getRef() instanceof ViewGUIElementReference) {
			objInQuestion = (abtractRef.getRef() as ViewGUIElementReference).getValue();
		}
		return objInQuestion instanceof ContentElement;
	}

//	private static def boolean isRestrictedToContainer(EObject context) {
//		var container = context;
//		while (container instanceof AbstractViewGUIElementRef) {
//			container = container.eContainer();
//		}
//		return validContainerForAbstractViews.contains(container.eClass());
//	}

//	private static def boolean isValidViewElement(EObject context, EObject obj) {
//		if (obj instanceof ViewElementType) {
//			if (isRestrictedToContainer(context)) {
//				if (obj instanceof ContentElement) {
//					return false;
//				} else if (obj instanceof ViewGUIElementReference) {
//					if(obj.getValue() instanceof ContentElement) return false;
//				}
//			}
//			return true;
//		}
//		return false;
//	}
}
