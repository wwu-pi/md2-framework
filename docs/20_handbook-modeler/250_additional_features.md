---
title: Advanced features of the MD² language
layout: default
order: 250
---

# Advanced features of the MD² language

## Calling RESTful Web Services from an App
With the current MD² version it is possible to call RESTful web services that are provided by external applications.
To do so, it is necessary to specify the web service's URL and REST method (currently *GET*, *POST*, *PUT* and *DELETE* are supported), as well as the parameters to be transferred to it.
The parameters are represented as <key, value> pairs and can be sent as query parameters and/or via the body of the request.
Accordingly, depending on the option expected by the service to be called, the DSL allows the modeler to specify queryparams or bodyparams.

Aside from static values to be set at design time, it is possible to set a parameter to the value of a particular `ContentProviderPath`, i.e. the value of a content provider's field, which is derived at run time.
If the value is set statically at design time the data types `String`, `Integer`, `Float` and `Boolean` are allowed (as they will internally be converted into JSON).

An exemplary web service description based on the DSL as well as the corresponding call of the action is depicted in the following.

```MD2
// Specification of the web service call
externalWebService <externalWebServiceCallOne> {
	url URL
	method (GET | POST | PUT | DELETE)
	queryparams(
		STRING : (INT | STRING | FLOAT | BOOLEAN | <ContentProviderPath>)
		STRING : (INT | STRING | FLOAT | BOOLEAN | <ContentProviderPath>)
		<...>
	)
	bodyparams (
		STRING : (INT | STRING | FLOAT | BOOLEAN | <ContentProviderPath>)
		<...>
	)
}

// Specify action to call the web service
action CustomAction <CustomActionOne> {
	call WebServiceCall <externalWebServiceCallOne>
}
```

## Controlling a Workflow by calling a RESTful Web Service
The MD² language offers a possibility to define a RESTful web service  which will start a certain workflow element.
For this purpose, for each workflow element marked as `invokable` a web service is generated with one endpoint for each invoke definition.

When an invoke definition is placed within a workflow element of the controller model, the respective workflow element in the workflow model has to be marked as invokable as well.
An event description can be added, which will be shown in the list of open issues as the event which was fired last.

```MD2
invokable at STRING using (POST | PUT) {
	<ContentProviderPath> as ALIAS
	default <ContentProviderPath> = <Value>
	set <ContentProviderPath> to <ContentProvider>
}
```

The minimally required invoke definition is simply the keyword `invokable`.
The standard path where an endpoint is injected is `/`.
If another path should be used this must be defined after the `at` keyword.
If multiple endpoints are defined, setting the path is mandatory.

The standard REST method used for the RESTful web service endpoint is *POST*.
However, after the keyword `using`, the modeller can choose `PUT` instead.
In the body of an invoke definition it can be defined if entities and their attributes should be set during the web service call.
Three different possibilities exist for this purpose.
In the following they are described in the order of their appearance within the aforementioned listing.

* The first type allows attribute values to be set by the web service call.
This means that the attribute is transformed to a parameter of the endpoint and is then set to the received value.
For the name of the parameter either the name of the attribute is used or an alternative alias can be defined.
* If some attributes should always receive the same value regardless of the parameter values, they can be set to a default value using the second type.
An example would be a status field which is set to "issue received" when the workflow is started.
* The last type is similar to setting a content provider to an attribute (cf. [DSL specification for the controller layer](230_single-apps.html)).
Since the language only knows how entities are related to each other, but not their corresponding content providers, this statement is needed for every nested entity.

For each entity referenced within the definition an instance of it will be created and persisted.
The type of persistence depends on whether the remote connection of the content provider equals the one of the `workflowManager`.
If they are equal, the web service call and the persistence is handled on the same server, thus the internal Enterprise JavaBeans can be used.
Otherwise, the other external backend server needs to be called - this is however not implemented in the current version of the MD².
It is not only necessary that the URLs of the remote connections are equal, but the objects also need to be identical.
If the body is missing, no entities or attributes are set.

## What's next
* [Getting started with the development of the MD² framework itself](../40_handbook-dev/)
