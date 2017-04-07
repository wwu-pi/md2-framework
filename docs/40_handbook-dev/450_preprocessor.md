---
title: Preprocessor
layout: default
order: 450
---

# Preprocessor

For each target platform, a generator class is created that implements the interface `IPlatformGenerator`.
Each generator class is registered in the `MD2RuntimeModule` and gets injected into the framework automatically.
During modeling, the Xtext Builder participant starts the building process every time a model file is saved with changes and regenerates the platform files.
Prior to generating the source code, the model gets transformed and is passed on to the implementing generator classes.
Basically, this step can be considered a model-to-model transformation with the aim to simplify the generation process.

## Model Combination
When MD² models are defined across multiple files (including the separation in model, view, and controller packages), the resulting model will also be split across multiple `MD2Models`.
To avoid that these models have to be recollected over and over again throughout the preprocessing process, all controllers, models, workflows and views are combined into a single model prior to the actual preprocessing.

## Autogenerator
The autogenerator is a feature that allows to easily create view elements from model definitions.
During the preprocessing, the references to content providers are resolved and content elements are created based on the model attribute types that the content provider declares.
The schema for generation is as follows:
*	`IntegerType`, `FloatType`, `StringType` become text input fields
* `DateType`, `TimeType`, `DateTimeType` become text input fields with corresponding time type attribution (later depicted as date/time pickers)
* `BooleanType` becomes a checkbox field
* `ReferencedType`
  * `Enum` becomes an option picker field
  * `Entites` are processed recursively and all elements are wrapped in a *flow layout pane*

### Remarks
For each content element, a new `MappingTask` is created that maps the content element to the attribute provided by the content provider.
For this purpose a *custom action* called "autoGenerationAction" is created that the platform generators need to parse.
If the view element is unmapped on startup or a user-specified mapping is found, the auto-generated mapping is removed.

In case the model attribute, from which a content element is created, has the optional parameters `name` or `description` set, these values are converted to label and tooltip representations for text inputs, option inputs and checkboxes.
If no name is given by the modeller, the ID of the content element will be assigned as a label name with each uppercase letter preceded by a whitespace (e.g. "myAddress" will be transformed into "My Address").

## Cloning and References
The MD² language allows the modeller to define certain view elements once and then reuse them multiple times.
Internally, these elements are copied and references pointing to them are resolved during the preprocessing.
The same behavior applies to view elements that are referenced in a view container (e.g. a flow layout pane) but are defined outside of this container.
The following example shall serve to illustrate these two use cases.

```MD2
TabbedPane mainView {
	customerPane -> customerView(tabTitle "Customer")
	generalPane -> generalView(tabTitle "General")
}
FlowLayoutPane customerPane(vertical) {
	headerPane
	TextInput myTextInput
}
FlowLayoutPane generalPane(vertical) {
	headerPane
	// Some view elements
}
FlowLayoutPane headerPane {
	Image logoImage("./capitol.png")
}
```

The code excerpt shows a tabbed pane that references two container elements.
These containers again reference the same sub-container twice.
After preprocessing, the model appears to the code generators as follows:

```MD2
TabbedPane mainView {
	FlowLayoutPane customerView(tabTitle "Customer", vertical) {
		FlowLayoutPane headerPane {
			Image logoImage("./capitol.png")
	    }
		TextInput myTextInput
	}
	FlowLayoutPane generalPane(tabTitle "General", vertical) {
		FlowLayoutPane headerPane {
			Image logoImage("./capitol.png")
		}
	}
}
```

### Resolving References
Because view elements can be reused and referenced across the whole model, MD² needs to provide means on how to use these virtual elements in behavioral elements like actions.
The problem is that Xtext only allows to reference the originating element, but not the reference itself.
In the example provided this means that the outer `headerPane` can be referenced, but any `headerPane` in a `customerPane` or `generalPane` can not, because there is no such element during runtime.
To solve this issue, MD² has the language type `AbstractViewGUIElementRef` that deals with these kind of references.
This element allows to chain references to any element of the model in an arbitrary order.
However, the scope has to be restricted to offer just the possible elements during autocompletion.
During preprocessing, the pseudo-referenced elements are converted into real elements as described befor, and any reference to them will be resolved.

The reference to `myTextInput` that resides in `customerPane` and is part of the tabbed pane `mainView` can be referenced as `mainView.customerView->customerPane.myTextInput`.
Basically, two elements are chained with `->` as the delimiter.

The modeller also might want to reference an auto-generated content element.
This is done by referencing the autogenerator followed by the model element in square brackets.
In the following customer scenario, the text input field that is later generated for the customer’s first name can be referenced as `myPane.customerAutoGenerator[Customer.firstName]`.

```MD2
FlowLayoutPane myPane {
	AutoGenerator customerAutoGenerator {
		contentProvider customerContentProvider
	}
}
contentProvider Customer customerContentProvider {
	providerType default
}

entity Customer {
	firstName: string
}
```

### Remarks
When a view element, which is referenced or reused at a different place, is copied, each event binding, mapping or validator binding pointing to this view element will be copied as well.
The copied version of the controller elements will be redirected to the copied version of the view elements.
This does not work the other way around: any behavior element pointing to a referencing view element does not apply to the original element.

## Validators
To ensure proper data integrity and to validate user input, each content element can be attributed with validators in a `ValidatorBindingTask`.
When a view element is mapped to a model attribute, some validators can be inferred automatically based on the attribute type (e.g. for integers) and its parameters (e.g. optional attributes).
In these cases a validator is automatically created and bound to the view element in question.
However, the modeler can still overwrite or unbind these validators in any actions that are performed upon startup.

### Type-Specific Validators
* `IntegerType` enforces a `StandardIsIntValidator` being bound
* `FloatType` enforces a `StandardIsNumberValidator` being bound
* `StringType` enforces a `StandardStringRangeValidator` being bound

### Type Parameter-Specific Validators
* Omitting the `optional` keyword will result in a `StandardNotNullValidator` being bound
* Setting `min` or `max` values for any kind of attribute will result in an appropriate validator being bound that ensures the range for this data type

## Replacements
### Enums
The MD² language allows to declare enums explicitly and implicitly.
Internally, all enums will be treated as explicitly defined enums and converted accordingly.

For example, before:
```MD2
entity User {
	gender: {"male", "female"}
}
```

After:
```MD2
entity User {
	gender: User_Gender
}
enum User_Gender {
	"male", "female"
}
```

### Process Chains
Nested process chains will be flattened.

Before:
```MD2
processChain pc1 {
	step firstStep:
		view mainView.customerView
	step nestedStep:
		subProcessChain pc2
	step thirdStep:
		view mainView.resultView
}
processChain pc2 {
	step secondStep:
		view mainView.InputView
}
```

After:
```MD2
processChain pc1 {
	step firstStep:
		view mainView.customerView
	step secondStep:
		view mainView.InputView
	step thirdStep:
		view mainView.resultView
}
```

### CombinedAction
The sole use of combined actions is to trigger the execution of other actions.
This behavior can also be achieved by using call tasks in custom actions.
Hence, all combined actions will be converted to custom actions internally.

### Miscellaneous
Some minor adjustments are made to the model:

* Check for existence of the `flowDirection` parameter for all flow layout panes.
* Duplicate spacer according to the specified number of spacers.
* Replace all named colours by their hex colour equivalents.
* Replace custom validators with standard validator definitions.

## TestGenerator
Usually model transformations are transparent to the modeler and even for the developer hard to trace.
With the test generator, though, there is a way to get a glimpse of the model's state as XMI definition before it gets passed to the platform generators.

## What's next
* [The structure of the backend generator](460_backend-generator.html)
* [The structure of the Android generator](470_android-generator.html)
* [The structure of the iOS generator](480_ios-generator.html)
