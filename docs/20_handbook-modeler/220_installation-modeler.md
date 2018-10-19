---
title: Setting up your MD² Model Development Environment
layout: default
order: 220
---

# Setting up your MD² Model Development Environment

The following steps will provide you with the software required to enable modelling of MD² models:

* Download and unzip a current Eclipse IDE for Java and DSL Developers (e.g., [Eclipse 2018-09 package](https://www.eclipse.org/downloads/packages/release/2018-09/r/eclipse-ide-java-and-dsl-developers)).
* Download the MD² plugins and the Google Multibindings jar file from the [MD² repository](https://github.com/wwu-pi/md2-framework/tree/master/plugins) and copy them to the `/plugins` directory of your Eclipse installation.
* Start Eclipse and import an MD² project, e.g. the `de.wwu.md2.simple` example from [https://github.com/wwu-pi/md2-testApps](https://github.com/wwu-pi/md2-testApps). Whenever you perform changes to a model and save the file, the generation process is triggered (visible as "Build workspace" message).

To run the generated Android app:
* Download a current version of Android Studio and open the generated project which was created in the `src-gen/projectName.lollipop` subdirectory of the sample project (accept the Gradle wrapper message). The first time, you may be requested to install different components (build tools etc.) matching your development environment. Now you can run the app in the emulator or on connected devices.
* Please note: Currently the generated app project is replaced (i.e., deleted) when re-generated (the respective files should not be open in other programs to avoid conflicts). Re-opening the project in Android Studio sometimes causes an incorrect "Unsupported Modules Detected" error message and the project cannot be built/run. Simply choose "Tool > Android > Sync Project with Gradle Files" and the project should be fixed.

## Setting up GlassFish to Run Generated Backends
To deploy the generated backends, follow the subsequent steps:

1. In Eclipse, open the "Servers" tab.
1. Right-click it and choose "New" > "Server".
1. If the GlassFish adapter is not installed yet (look for "GlassFish" in the list of types), click "Download additional server adapters" and install the entry "GlassFish Tools".
1. From the list of types, choose "GlassFish" > "GlassFish 4.0" and click "Next".
1. For the Glassfish Server Directory field, navigate to the `glassfish/` subdirectory in your installation.
If you entered the correct path, it should output something similar to ```Found GlassFish Server version 4.0.0```.
	Otherwise, follow the assistant's hints.
1. Click "Finish".

## What's next
* [Getting started with building single apps](230_single-apps.html)
* [Information needed for the development of multiple apps](240_multiple-apps.html)
