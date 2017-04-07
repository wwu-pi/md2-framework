---
title: Development TODOs and ideas for improvements
layout: default
order: 495
---

# Development TODOs and ideas for improvements

* This list might be moved to Github issues allowing for discussion.

## DSL improvements
* Move content providers to model layer
  * avoid bi-directional reference between controller layer (current position of content providers) and view layer (in particular autolayout which uses these providers).
* renaming of workflow elements should be allowed in the model in a way that different apps can use the same workflow element using different names for them
  * This way, it would be possible to determine very precisely which workflow element in which app is to be started rather than starting a workflow element which can be processed by any app that has the respective workflow element assigned.
* return values when external webservices are called
  * This would enable programmers to include almost arbitrary functionality in the model without the need to offer it as explicit construct in the DSL. The only requirement is that return values comply with the data types supported by the MD² framework to ensure that they can be used in a purposeful way.
* call other external applications apart from REST
* allow the definition of custom icons for startable elements
* support white spaces in project names
* support temporary offline usage
* access foreign apps such as the phone, camera and GPS
* customizable columns within the list of open issues
* unify UploadedImageOutput and Image fields

## Tooling improvements
* Improve validators
  * check whether the fire event action in a workflow element is the last action and warn if it is not. This can be helpful, for example, when a save action follows a fire event action. In this case, saving data will not be performed, since the fire event action immediately forwards control to the next workflow element.
  * throw warnings or errors when a controller maps something to view elements which are never used by the controller, e.g. mapping something to a view which only appears in a different app
  * check whether all content providers are saved, in order to ensure that a modeller does not forget any save actions.
* provide auto formatting in the IDE

## Documentation
* [Elaborate on View layer](040_dsl-semantics.html)
* [Getting Started with MD² Development](030_getting-started-dev.html)
* [Android generator](070_android-generator.html)
* [iOS generator](080_ios-generator.html)

## Preprocessor improvements
* generate only relevant content for each app, e.g. only generate entities which are used by the apps,

## Backend generator improvements
* Check gradle build without manually passing jar files
* Provide backend as Docker container
* File upload only supports jpg

## Android generator improvements
* extend to feature parity with MD² language
* Implement EntitySelector

## iOS generator modifications
* extend to feature parity with MD² language
* Implement EntitySelector
