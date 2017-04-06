---
title: Test
layout: default
---

# Development Environment

To simplify development, the initial setup is mostly automated using build scripts (and automation is further improved in future). Therefore, Gradle should be installed on the system first.
The installation was tested with Eclipse Neon 3 and Xtext 2.11.0 (March 2017).

1. Clone the repository to the local machine using `git clone https://github.com/wwu-pi/md2-framework.git`.
1. Cd into `/md2-framework` and initialize the project with `gradle setupMD2`. The first time, this will take a few minutes to download the dependencies. There might be quite some warnings but it should be fine if you find the line `[main] INFO  .emf.mwe2.runtime.workflow.Workflow  - Done.` in the middle and the Gradle script exits successfully.
1. Download and unzip the [Eclipse Modeling Tools package](http://www.eclipse.org/downloads/packages/eclipse-modeling-tools/neon3).
1. Start Eclipse and choose a workspace of your choice.
1. Go to `Help` > `Install New Software...`, click on `Add...`, enter the Xtext Update Site `http://download.eclipse.org/modeling/tmf/xtext/updates/composite/releases/`.
1. Install at least the `Xtext Complete SDK` and `Xtend IDE` components from the `Xtext` branch and restart Eclipse (there seems to be some issue when installing Xtext 2.11 in current Eclipse Neon due to the component "EMF Parsley". If asked you can update your installation and let Eclipse remove the conflicting component).
1. Switch to the Java perspective (red icon in top right corner) or open it first.
1. In Eclipse, choose `File` > `Import` > `Existing Projects into Workspace`, select the directory created in step 1 as root directory, and import the `de.wwu.md2.framework` and `de.wwu.md2.framework.ui` projects contained in the local MD2 repository.
1. Happy coding! To see your changes, run the `de.wwu.md2.framework` project as Eclipse Application. This way, the current projects are installed as plugins and you can test the modeling environment. End users should use the setup instructions in the modeler's section to avoid running this Eclipse-in-Eclipse construct.

## What's next
* [Getting Started with the development](030_getting-started-dev.html)
* [Md² DSL semantics](040_dsl-semantics.html)
