define([
    "dojo/_base/declare", "./JsonFormBuilder"
], function(declare, JsonFormBuilder) {

    return declare([], {
        // injected form controls
        formControls: undefined,
        /**
         * checks if formResolveDescription is the json required by a JsonFormBuilder and creates one.
         * @return {dataform.api.JsonFormBuilder} the builder
         */
        resolveBuilder: function(formResolveDescription) {
            if (!formResolveDescription) {
                return undefined;
            }
            var version = formResolveDescription["dataform-version"];
            if (version !== "1.0.0") {
                return undefined;
            }
            return new JsonFormBuilder({
                definition: formResolveDescription,
                controlFactory: this.formControls
            });
        }
    });
});