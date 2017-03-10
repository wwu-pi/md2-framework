# MD² – Model-driven Mobile Development
MD² is a framework for cross-platform development of native business apps.
For more information, please visit the [MD² website](http://wwu-pi.github.io/md2-web/).

This repository contains the latest source code, which may be unstable.
MD²'s source code is made available as open source under Apache License 2.0.

## Installation for DSL users
TODO

## Installation for developers
To simplify development, initial setup is mostly automated using build scripts (and automation is further improved in future). Therefore, Gradle should be installed on the system first.
The installation was tested with Eclipse Neon 2 and Xtext 2.11.0 (March 2017).

1. Clone the repository to the local machine using `git clone https://github.com/wwu-pi/md2-framework.git`.
1. Cd into `/md2-framework` and initialize the project with `gradle setupMD2`. The first time, this will take a few minutes to download the dependencies. There might be some warnings but it should be fine if you find the line `[main] INFO  .emf.mwe2.runtime.workflow.Workflow  - Done.` in the middle.
1. Download and unzip the [Eclipse Modeling Tools package](http://www.eclipse.org/downloads/packages/eclipse-modeling-tools/neon2).
1. Start Eclipse and choose a workspace of your choice.
1. Go to `Help` > `Install New Software...`, click on `Add...`, enter the Xtext update site `http://download.eclipse.org/modeling/tmf/xtext/updates/composite/releases/`.
1. Install at least the `Xtext Complete SDK` and `Xtend IDE` components from the `Xtext` branch and restart Eclipse (there seems to be some issue when installing Xtext 2.11 in current Eclipse Neon due to the component "EMF Parsley". If asked you can update your installation and let Eclipse remove the conflicting component).
1. Switch to the Java perspective (red icon in top right corner) or open it first.
1. Import the `de.wwu.md2.framework` and `de.wwu.md2.framework.ui` projects contained in the local MD2 repository.
1. Happy coding! To see your changes, run the de.wwu.md2.framework project as Eclipse Application. This way, the current projects are installed as plugins and you can test the modeling environment. End users should use the setup instructions in the previous chapter to avoid running this Eclipse-in-Eclipse construct.

Additional (but potentially outdated) information can be found in the Installation section of the Developer's Handbook chapter in the [MD² documentation](https://github.com/ps-md2/md2-documentation) for information on how to set up the development environment for MD².

## Pull requests welcome!

Spotted an error? Something doesn't make sense? Ideas for improvement? Open an issue or send a pull request!

Questions/Problems? Feel free to [ask](http://erc.is/p/rieger) [@riegerchris](http://github.com/riegerchris)
