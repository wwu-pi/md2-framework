---
title: Test
layout: default
---

# DSL semantics

The MD² framework is intended to provide a cross-platform solution for multiple mobile platforms such as Android or iOS.
For this purpose, this section delivers an overview about the semantics of the DSL, e.g. the different patterns targeted or forms of communication that are implied by certain model constructs.
This will enable future developers to generate apps for other platforms which provide the same functionality as the apps currently generated from the DSL.

First of all, the Model-View-Controller (MVC) pattern with an additional workflow layer used in the DSL should also be represented in the generated code.

## Workflow Layer
The workflow layer defines different apps and their workflow elements.
Since workflows bundle specific functionality, each app can be seen as a user role, and the assigned workflow elements represent the role's permissions.
However, a sophisticated user or role management within the generated apps is not implemented in the MD² framework.

Every app is supposed to have a start screen which contains buttons for workflow elements that can be started in the app as well as a list of open issues (workflow instances in a specific state) that can be continued by the app.
The mapping of workflow elements to corresponding roles is stored in the backend, which connects workflow elements to their apps.
This is for example important for the determination of open issues which might be created by one role and then need to be continued by another app.

Similar to that, the backend needs to know the sequence of workflow elements, i.e. which workflow elements are to be started after which event and when to end the workflow.
Note, that two different workflow elements can fire the same event and start different workflow elements.
Thus, the backend also needs to know which combination of event and workflow element initializes the start of a specific new workflow element.

However, to avoid unnecessary backend communication, transitions between workflow elements within the same app should be handled by the app-specific workflow manager.
This is important to allow temporary off-line usage of apps in the future.
Thus, the backend handles the start of new workflows *across* apps (currently implemented as `EventHandlerWS`) and the app-specific event handler is responsible to start new workflow elements *within* apps.

When a workflow element is started across apps, it will appear in the list of open issues of all apps that have the respective workflow element assigned.

## Model Layer
The model is a rather thin layer in the overall architecture, the only components contained are entities and enumerations.
In order to access core data functionality, a global data model has to be setup that defines the database structure to be accessed later through content providers.
This database is currently located in the backend and is accessible via RESTful web services for apps from all platforms.

## View Layer
View elements should be implemented with the functionality described in the [Modeler's handbook](510_introduction-modeler.html).

# Controller Layer
The biggest and most important layer in this architecture is the controller layer, which has the role to connect the view with the model and vice versa.

It consists of several workflow elements, each being an independent controller describing a *logical step in the process* to be accomplished by the app user.
In contrast, a process chain contains more *fine-grained process steps* that boils down to individual views shown to the app user.
For illustration, a process that requires the user to enter data (say, a list of dishes to order) and then perform the payment consists of those two logical steps represented by workflow elements.
The payment itself might be split into an input view and a validation screen, both of which would be elements of the process chain within the payment workflow element.

Technically, the default process chain of a workflow element should be used as starting process chain.
Likewise, the first view from this process chain should be used as start view for the workflow element.
Each workflow element (i.e. each controller) requires its own initialization, e.g. mappings of content to views.
The required actions for this initialization can be found in the `onInit` block in a workflow element.
When a workflow element fires a workflow event (in particular after completing the last process chain step), it should be terminated and the control handed to the app-specific event handler.
Depending on the next workflow eleent to start the handler might communicate the state of the workflow to the backend (as described above for the workflow layer).

Within the body of workflow elements, the controller behavior can be defined using actions and process chains.
Process chains will be converted to actions in the [preprocessor](050_preprocessor.html), and therefore do not require specific handling by the generators.

Content providers in the controller layer are used for data provisioning, either locally using a `LocalContentProvider` or by the server backend using `RemoteContentProvider`.
RESTful webservice-based communication to the backend is required for every platform in order to store and request the remotely stored data.

## What's next
* [The preprocessor](050_preprocessor.html)
* [The structure of the backend generator](060_backend-generator.html)
* [The structure of the Android generator](070_android-generator.html)
* [The structure of the iOS generator](080_ios-generator.html)
