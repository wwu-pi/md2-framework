define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "testActions",
		
		execute: function() {
			
			var messageExpression = function() {
				return this.$.create("string", "Hurray ... This is an MD2 message!").toString();
			};
			var action = this.$.actionFactory.getDisplayMessageAction("eced5417eaa969793b313a1d9347b31d", messageExpression);
			action.execute();
			
			var messageExpression03 = function() {
				return this.$.create("string", this.$.create("string", this.$.create("string", "And now a message with an expression.").toString()
				.concat(this.$.create("string", " 4 + 4 = "))
				).toString()
				.concat(this.$.create("float", (this.$.create("integer", 4).getPlatformValue() + this.$.create("integer", 4).getPlatformValue())))
				).toString();
			};
			var action02 = this.$.actionFactory.getDisplayMessageAction("27f58e6e0e54c53bfdb33e25109d5b4e", messageExpression03);
			action02.execute();
			
			var messageExpression05 = function() {
				return this.$.create("boolean", true).toString();
			};
			var action04 = this.$.actionFactory.getDisplayMessageAction("d3da3c486b89dad5f81b4c12697c5dac", messageExpression05);
			action04.execute();
			
			var action06 = this.$.actionFactory.getDisableAction("lastName");
			action06.execute();
			
			var action07 = this.$.actionFactory.getEnableAction("firstName");
			action07.execute();
			
		}
		
	});
});
