define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "testActions",
		
		execute: function() {
			
			var messageExpression04x = function() {
				return this.$.create("string", "Hurray ... This is an MD2 message!").toString();
			};
			var action04w = this.$.actionFactory.getDisplayMessageAction("eced5417eaa969793b313a1d9347b31d", messageExpression04x);
			action04w.execute();
			
			var messageExpression04z = function() {
				return this.$.create("string", this.$.create("string", this.$.create("string", "And now a message with an expression.").toString()
				.concat(this.$.create("string", " 4 + 4 = "))
				).toString()
				.concat(this.$.create("float", (this.$.create("integer", 4).getPlatformValue() + this.$.create("integer", 4).getPlatformValue())))
				).toString();
			};
			var action04y = this.$.actionFactory.getDisplayMessageAction("27f58e6e0e54c53bfdb33e25109d5b4e", messageExpression04z);
			action04y.execute();
			
			var messageExpression051 = function() {
				return this.$.create("boolean", true).toString();
			};
			var action050 = this.$.actionFactory.getDisplayMessageAction("d3da3c486b89dad5f81b4c12697c5dac", messageExpression051);
			action050.execute();
			
			var action052 = this.$.actionFactory.getDisableAction("lastName");
			action052.execute();
			
			var action053 = this.$.actionFactory.getEnableAction("firstName");
			action053.execute();
			
		}
		
	});
});
