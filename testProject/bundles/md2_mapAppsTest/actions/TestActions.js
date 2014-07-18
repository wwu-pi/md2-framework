define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "testActions",
		
		execute: function() {
			
			var messageExpression0gp = function() {
				return this.$.create("string", "Hurray ... This is an MD2 message!").toString();
			};
			var action0go = this.$.actionFactory.getDisplayMessageAction("eced5417eaa969793b313a1d9347b31d", messageExpression0gp);
			action0go.execute();
			
			var messageExpression0gr = function() {
				return this.$.create("string", this.$.create("string", this.$.create("string", "And now a message with an expression.").toString()
				.concat(this.$.create("string", " 4 + 4 = "))
				).toString()
				.concat(this.$.create("float", (this.$.create("integer", 4).getPlatformValue() + this.$.create("integer", 4).getPlatformValue())))
				).toString();
			};
			var action0gq = this.$.actionFactory.getDisplayMessageAction("27f58e6e0e54c53bfdb33e25109d5b4e", messageExpression0gr);
			action0gq.execute();
			
			var messageExpression0gt = function() {
				return this.$.create("boolean", true).toString();
			};
			var action0gs = this.$.actionFactory.getDisplayMessageAction("d3da3c486b89dad5f81b4c12697c5dac", messageExpression0gt);
			action0gs.execute();
			
			var action0gu = this.$.actionFactory.getDisableAction("lastName");
			action0gu.execute();
			
			var action0gv = this.$.actionFactory.getEnableAction("firstName");
			action0gv.execute();
			
		}
		
	});
});
