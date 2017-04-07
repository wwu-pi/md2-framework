---
title: Developing multiple apps
layout: default
order: 240
---

# Developing multiple apps

The MD² framework allows to model and generate workflows that involve multiple apps.
For this purpose, several apps rather than just one can be specified in the workflow layer.
These apps can share the same workflow elements or use different ones as shown in the first listing.
Apart from that, the workflow will look as usual, with the sequence of workflow elements being determined via events.
Each app is provided with a list of open issues in the start screen.
In this list, all events are presented that were fired from another app and are supposed to start a workflow element which belongs to the current app.
A user can simply click on a listed issue to continue the workflow in the appropriate workflow element.

```MD2
package <ProjectName>.workflows

WorkflowElement <WorkflowElementOne>
<...>
WorkflowElement <WorkflowElementTwo>
<...>
WorkflowElement <WorkflowElementThree>
<...>

App <AppID1> {
	<WorkflowElementOne> (startable: STRING),
	<WorkflowElementTwo>
}

App <AppID2> {
	<WorkflowElementOne>,
	<WorkflowElementThree>
}
```

The deployment of multiple apps is similar to that of a single app.
In this case, however, not just one but all created apps have to be deployed as described in the [previous section](530_single-apps.html) for each app.

## What's next
* [information about more advanced additional features of the language](550_additional_features.html)
