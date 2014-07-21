define([
	"dojo/_base/declare",
	"../../md2_runtime/actions/_Action"
],
function(declare, _Action) {
	
	return declare([_Action], {
		
		_actionSignature: "testActions",
		
		execute: function() {
			
			var messageExpression03f = function() {
				return this.$.create("string", "Hurray ... This is an MD2 message!").toString();
			};
			var action03e = this.$.actionFactory.getDisplayMessageAction("eced5417eaa969793b313a1d9347b31d", messageExpression03f);
			action03e.execute();
			
			var messageExpression03h = function() {
				return this.$.create("string", this.$.create("string", this.$.create("string", "And now a message with an expression.").toString()
				.concat(this.$.create("string", " 4 + 4 = "))
				).toString()
				.concat(this.$.create("float", (this.$.create("integer", 4).getPlatformValue() + this.$.create("integer", 4).getPlatformValue())))
				).toString();
			};
			var action03g = this.$.actionFactory.getDisplayMessageAction("27f58e6e0e54c53bfdb33e25109d5b4e", messageExpression03h);
			action03g.execute();
			
			var messageExpression03j = function() {
				return this.$.create("boolean", true).toString();
			};
			var action03i = this.$.actionFactory.getDisplayMessageAction("d3da3c486b89dad5f81b4c12697c5dac", messageExpression03j);
			action03i.execute();
			
			var action03k = this.$.actionFactory.getDisableAction("lastName");
			action03k.execute();
			
			var action03l = this.$.actionFactory.getEnableAction("firstName");
			action03l.execute();
			
		}
		
	});
});
