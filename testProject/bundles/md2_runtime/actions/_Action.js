define([
    "dojo/_base/declare"
],
function(declare) {
    /**
     * Interface for actions.
     */
    return declare([], {
        
        /**
         * Set a unique signature for the action. For custom actions that is the actionName,
         * for simple action this is the action name, plus the parameter signature provided
         * by the preprocessing.
         */
        _actionSignature: "undefined",
        
        /**
         * Implementation of the actual action.
         */
        execute: function() {
            
        },
        
        /**
         * Compare a given action with this action, based on the action name and
         * its parameter values.
         * @param {type} otherAction
         */
        equals: function(otherAction) {
            return this._actionSignature === otherAction._actionSignature;
        }
    });
});
