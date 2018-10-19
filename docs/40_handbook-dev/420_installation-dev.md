---
title: Development Environment
layout: default
order: 420
---

# Development Environment

To simplify development, the initial setup is mostly automated using build scripts (and automation is further improved in future). Therefore, Gradle should be installed on the system first.
The installation was tested with Eclipse 2018-09 and Xtext 2.15 (October 2018).

1. Clone the repository to the local machine using `git clone https://github.com/wwu-pi/md2-framework.git`.
1. Cd into `/md2-framework` and initialize the project with `gradle assemble`. The first time, this will take a few minutes to download the dependencies. There might be quite some warnings but it should be fine if you find the line `[main] INFO  .emf.mwe2.runtime.workflow.Workflow  - Done.` in the middle and the Gradle script exits successfully.
1. Download and unzip a current Eclipse IDE for Java and DSL Developers (e.g., [Eclipse 2018-09 package](https://www.eclipse.org/downloads/packages/release/2018-09/r/eclipse-ide-java-and-dsl-developers)).
1. Start Eclipse and choose a workspace of your choice.
1. Choose `File` > `Import` > `Existing Projects into Workspace`, select the directory created in step 1 as root directory, and import at least the `de.wwu.md2.framework`, `de.wwu.md2.ide`, and `de.wwu.md2.framework.ui` projects contained in the local MD2 repository.
1. Happy coding! To see your changes, run the `de.wwu.md2.framework` project as Eclipse Application. This way, the current projects are installed as plugins and you can test the modeling environment. End users should use the setup instructions in the modeler's section to avoid running this Eclipse-in-Eclipse construct.

## What's next
* [Getting Started with the development](430_getting-started-dev.html)
* [Md² DSL semantics](440_dsl-semantics.html)
