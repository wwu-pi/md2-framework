package de.wwu.md2.framework.generator.ios.workflow

import de.wwu.md2.framework.mD2.WorkflowElementEntry
import de.wwu.md2.framework.mD2.WorkflowElementReference
import org.eclipse.emf.common.util.EList

/**
 * Generate workflow-related Swift code required to setup the workflow layer.
 */
class IOSWorkflow {
	
	/**
	 * Generate workflow element references for the MD2Controller class.
	 * 
	 * @param elements The list of workflow element references.
	 * @return The workflow element declaration block for the MD2Controller class.
	 */
	def static String generateWorkflowElements(Iterable<WorkflowElementReference> elements) '''
«FOR wfe : elements»
    
    let wfe«wfe.workflowElementReference.name.toFirstUpper» = MD2WorkflowElement(name: "«wfe.workflowElementReference.name.toFirstUpper»", onInit: MD2CustomAction___«wfe.workflowElementReference.name.toFirstUpper»_startupAction())
    «IF wfe.startable == true»
    MD2WorkflowManager.instance.addStartableWorkflowElement(wfe«wfe.workflowElementReference.name.toFirstUpper», withCaption: "«IF wfe.alias != null»«wfe.alias»«ELSE»«wfe.workflowElementReference.name»«ENDIF»", forWidget: MD2WidgetMapping.__startScreen_Button_«wfe.workflowElementReference.name»)
    «ENDIF»
«ENDFOR»
	'''
	
	/**
	 * Generate the workflow event registration for the MD2Controller class.
	 * 
	 * @param elements The list of workflow event entries.
	 * @return The workflow event registration block for the MD2Controller class.
	 */
	def static String generateWorkflowEventRegistration(EList<WorkflowElementEntry> elements) '''
«FOR fireEventEntry : elements.map[wfeEntry | wfeEntry.firedEvents.toList ].flatten»
        
    MD2WorkflowEventHandler.instance.registerWorkflowElement(
        MD2WorkflowEvent.«fireEventEntry.event.name.toFirstUpper»,
        «IF fireEventEntry.endWorkflow»
        action: MD2WorkflowAction.End,
        workflowElement: wfe«(fireEventEntry.eContainer as WorkflowElementEntry).workflowElement.name.toFirstUpper»)
        «ELSE»
        action: MD2WorkflowAction.Start,
        workflowElement: wfe«fireEventEntry.startedWorkflowElement.name.toFirstUpper»)
        «ENDIF»
«ENDFOR»
	'''
	
}