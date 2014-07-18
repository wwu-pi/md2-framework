define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "testActions",
		
		execute: function() {
			
			var messageExpression0z = function() {
				return this.$.create("string", "Hurray ... This is an MD2 message!").toString();
			};
			var action0y = this.$.actionFactory.getDisplayMessageAction("eced5417eaa969793b313a1d9347b31d", messageExpression0z);
			action0y.execute();
			
			var messageExpression011 = function() {
				return this.$.create("string", this.$.create("string", this.$.create("string", "And now a message with an expression.").toString()
				.concat(this.$.create("string", " 4 + 4 = "))
				).toString()
				.concat(this.$.create("float", (this.$.create("integer", 4).getPlatformValue() + this.$.create("integer", 4).getPlatformValue())))
				).toString();
			};
			var action010 = this.$.actionFactory.getDisplayMessageAction("27f58e6e0e54c53bfdb33e25109d5b4e", messageExpression011);
			action010.execute();
			
			var messageExpression013 = function() {
				return this.$.create("boolean", true).toString();
			};
			var action012 = this.$.actionFactory.getDisplayMessageAction("d3da3c486b89dad5f81b4c12697c5dac", messageExpression013);
			action012.execute();
			
			var action014 = this.$.actionFactory.getDisableAction("lastName");
			action014.execute();
			
			var action015 = this.$.actionFactory.getEnableAction("firstName");
			action015.execute();
			
		}
		
	});
});
