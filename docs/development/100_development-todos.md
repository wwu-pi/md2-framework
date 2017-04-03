# Development TODOs and ideas for improvements

* This list might be moved to Github issues allowing for discussion.

## DSL modifications
* Move content providers to model layer
  * avoid bi-directional reference between controller layer (current position of content providers) and view layer (in particular autolayout which uses these providers).

## Documentation
* [Elaborate on View layer](040_dsl-semantics.html)
* [Getting Started with MD² Development](030_getting-started-dev.html)

## Backend generator modifications
* Check gradle build without manually passing jar files
* Provide backend as Docker container
* File upload only supports jpg
