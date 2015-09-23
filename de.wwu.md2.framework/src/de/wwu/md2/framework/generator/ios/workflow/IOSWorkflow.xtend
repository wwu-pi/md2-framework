package de.wwu.md2.framework.generator.ios.workflow

import de.wwu.md2.framework.mD2.WorkflowElementEntry
import de.wwu.md2.framework.mD2.WorkflowElementReference
import org.eclipse.emf.common.util.EList

class IOSWorkflow {
	
	def static String generateWorkflowElements(Iterable<WorkflowElementReference> elements) '''
«FOR wfe : elements»
    
    let wfe«wfe.workflowElementReference.name.toFirstUpper» = MD2WorkflowElement(name: "«wfe.workflowElementReference.name.toFirstUpper»", onInit: MD2CustomAction___«wfe.workflowElementReference.name.toFirstUpper»_startupAction())
    «IF wfe.startable == true»
    MD2WorkflowManager.instance.addStartableWorkflowElement(wfe«wfe.workflowElementReference.name.toFirstUpper», withCaption: "«IF wfe.alias != null»«wfe.alias»«ELSE»«wfe.workflowElementReference.name»«ENDIF»", forWidget: MD2WidgetMapping.__startScreen_Button_«wfe.workflowElementReference.name»)
    «ENDIF»
«ENDFOR»
	'''
	
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