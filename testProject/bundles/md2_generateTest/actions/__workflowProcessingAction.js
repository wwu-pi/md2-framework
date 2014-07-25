define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "__workflowProcessingAction",
		
		execute: function() {
			
			var bool017 = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider").getValue("currentWorkflowStep").equals(this.$.create("string", "myWf__step1"));
			var bool018 = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider").getValue("currentWorkflowStep").equals(this.$.create("string", "myWf__step2"));
			var bool019 = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider").getValue("currentWorkflowStep").equals(this.$.create("string", "myWf__step3"));
			var bool01a = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider").getValue("currentWorkflowStep").equals(this.$.create("string", "myWf__step4"));
			var bool01b = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider").getValue("currentWorkflowStep").equals(this.$.create("string", "myWf__step5"));
			if (bool017) {
				var bool01c = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider").getValue("lastEventFired").equals(this.$.create("string", "__contentProvider.customer.expectedSales.onChange"));
				if (bool01c) {
					var targetContentProvider01d = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider");
					var set01e = this.$.create("string", "myWf__step3");
					targetContentProvider01d.setValue("currentWorkflowStep", set01e);
					
					var targetContentProvider01f = this.$.contentProviderRegistry.getContentProvider("__returnStepStackProvider");
					var set01g = this.$.create("string", "myWf__step2");
					targetContentProvider01f.setValue("returnAndProceedStep", set01g);
					
					var targetContentProvider01h = this.$.contentProviderRegistry.getContentProvider("__returnStepStackProvider");
					var set01i = this.$.create("string", "");
					targetContentProvider01h.setValue("returnAndReverseStep", set01i);
					
					var targetContentProvider01j = this.$.contentProviderRegistry.getContentProvider("__returnStepStackProvider");
					var set01k = this.$.create("string", "myWf__step1");
					targetContentProvider01j.setValue("returnStep", set01k);
					
					var action01l = this.$.actionFactory.getCustomAction("__workflowExecuteStepAction");
					action01l.execute();
				}
			}
			else if (bool018) {
			}
			else if (bool019) {
				var bool01m = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider").getValue("lastEventFired").equals(this.$.create("string", "__gui.thirdView.continue.onClick")) &&
				!(this.$.widgetRegistry.getWidget("isSkipNextStep").getValue().equals(this.$.create("boolean", true)));
				var bool01n = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider").getValue("lastEventFired").equals(this.$.create("string", "__gui.thirdView.continue.onClick"));
				if (bool01m) {
					var targetContentProvider01o = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider");
					var set01p = this.$.create("string", "myWf__step4");
					targetContentProvider01o.setValue("currentWorkflowStep", set01p);
					
					var action01q = this.$.actionFactory.getCustomAction("__workflowExecuteStepAction");
					action01q.execute();
				}
				else if (bool01n) {
					var targetContentProvider01r = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider");
					var set01s = this.$.create("string", "myWf__step5");
					targetContentProvider01r.setValue("currentWorkflowStep", set01s);
					
                                        console.log(this.$.contentProviderRegistry.getContentProvider("__returnStepStackProvider").getContent());
					var targetContentProvider01t = this.$.contentProviderRegistry.getContentProvider("__returnStepStackProvider");
					var set01u = this.$.contentProviderRegistry.getContentProvider("__returnStepStackProvider").getContent();
					targetContentProvider01t.setValue("tail", set01u);
					console.log(this.$.contentProviderRegistry.getContentProvider("__returnStepStackProvider").getContent());
                                        
					var targetContentProvider01v = this.$.contentProviderRegistry.getContentProvider("__returnStepStackProvider");
					var set01w = this.$.create("string", "myWf__step4");
					targetContentProvider01v.setValue("returnAndProceedStep", set01w);
					
					var targetContentProvider01x = this.$.contentProviderRegistry.getContentProvider("__returnStepStackProvider");
					var set01y = this.$.create("string", "myWf__step2");
					targetContentProvider01x.setValue("returnAndReverseStep", set01y);
					
					var targetContentProvider01z = this.$.contentProviderRegistry.getContentProvider("__returnStepStackProvider");
					var set020 = this.$.create("string", "myWf__step3");
					targetContentProvider01z.setValue("returnStep", set020);
					
					var action021 = this.$.actionFactory.getCustomAction("__workflowExecuteStepAction");
					action021.execute();
				}
			}
			else if (bool01a) {
				var bool022 = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider").getValue("lastEventFired").equals(this.$.create("string", "__gui.fourthView.next.onClick")) &&
				(
					this.$.widgetRegistry.getWidget("yourName").getValue().equals(this.$.create("string", "George")) ||
					this.$.widgetRegistry.getWidget("yourName").getValue().equals(this.$.create("string", "Bill"))
				);
				var bool023 = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider").getValue("lastEventFired").equals(this.$.create("string", "__gui.fourthView.prev.onClick"));
				var bool024 = (
					this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider").getValue("lastEventFired").equals(this.$.create("string", "__gui.fourthView.next.onClick")) ||
					this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider").getValue("lastEventFired").equals(this.$.create("string", "__gui.fourthView.prev.onClick"))
				);
				if (bool022) {
					var targetContentProvider025 = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider");
					var set026 = this.$.create("string", "myWf__step5");
					targetContentProvider025.setValue("currentWorkflowStep", set026);
					
					var action027 = this.$.actionFactory.getCustomAction("__workflowExecuteStepAction");
					action027.execute();
				}
				else if (bool023) {
					var targetContentProvider028 = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider");
					var set029 = this.$.create("string", "myWf__step3");
					targetContentProvider028.setValue("currentWorkflowStep", set029);
					
					var action02a = this.$.actionFactory.getCustomAction("__workflowExecuteStepAction");
					action02a.execute();
				}
				else if (bool024) {
					var messageExpression02c = function() {
						return this.$.create("string", "Come on... I told you to enter Bill or George to proceed!").toString();
					};
					var action02b = this.$.actionFactory.getDisplayMessageAction("", messageExpression02c);
					action02b.execute();
				}
			}
			else if (bool01b) {
				var bool02d = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider").getValue("lastEventFired").equals(this.$.create("string", "__gui.fifthView.prev.onClick"));
				var bool02e = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider").getValue("lastEventFired").equals(this.$.create("string", "__gui.fifthView.returnTo3.onClick")) &&
				this.$.create("float", (this.$.widgetRegistry.getWidget("num1").getValue().getPlatformValue() + this.$.widgetRegistry.getWidget("num2").getValue().getPlatformValue())).equals(this.$.create("integer", 8));
				var bool02f = (
					this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider").getValue("lastEventFired").equals(this.$.create("string", "__gui.fifthView.prev.onClick")) ||
					this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider").getValue("lastEventFired").equals(this.$.create("string", "__gui.fifthView.returnTo3.onClick"))
				);
				if (bool02d) {
					var targetContentProvider02g = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider");
					var set02h = this.$.create("string", "myWf__step4");
					targetContentProvider02g.setValue("currentWorkflowStep", set02h);
					
					var action02i = this.$.actionFactory.getCustomAction("__workflowExecuteStepAction");
					action02i.execute();
				}
				else if (bool02e) {
					var targetContentProvider02j = this.$.contentProviderRegistry.getContentProvider("__workflowControllerStateProvider");
					var set02k = this.$.contentProviderRegistry.getContentProvider("__returnStepStackProvider").getValue("returnStep");
					targetContentProvider02j.setValue("currentWorkflowStep", set02k);
					
					var targetContentProvider02l = this.$.contentProviderRegistry.getContentProvider("__returnStepStackProvider");
					var set02m = this.$.contentProviderRegistry.getContentProvider("__returnStepStackProvider").getValue("tail");
					targetContentProvider02l.setContent(set02m);
					
					var action02n = this.$.actionFactory.getCustomAction("__workflowExecuteStepAction");
					action02n.execute();
				}
				else if (bool02f) {
					var messageExpression02p = function() {
						return this.$.create("string", this.$.create("string", this.$.create("string", this.$.create("string", this.$.create("string", this.$.create("string", this.$.create("string", "Something is wrong with your calculation...").toString()
						.concat(this.$.widgetRegistry.getWidget("num1").getValue())
						).toString()
						.concat(this.$.create("string", "+"))
						).toString()
						.concat(this.$.widgetRegistry.getWidget("num2").getValue())
						).toString()
						.concat(this.$.create("string", " is "))
						).toString()
						.concat(this.$.create("float", (this.$.widgetRegistry.getWidget("num1").getValue().getPlatformValue() + this.$.widgetRegistry.getWidget("num2").getValue().getPlatformValue())))
						).toString()
						.concat(this.$.create("string", ", not 8!"))
						).toString();
					};
					var action02o = this.$.actionFactory.getDisplayMessageAction("", messageExpression02p);
					action02o.execute();
				}
			}
			
		}
		
	});
});
