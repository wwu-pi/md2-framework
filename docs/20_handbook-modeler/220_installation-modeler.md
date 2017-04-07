---
title: Setting up your MD² Model Development Environment
layout: default
order: 220
---

# Setting up your MD² Model Development Environment

The following steps will provide you with the software required to enable modelling of MD² models:

* Download a current Eclipse IDE with support for Java EE development (e.g. Neon package).
* Install a current version of the Xtext redistributable using the [Xtext Update Site](https://eclipse.org/Xtext/download.html).
* Install the MD² features from the archive that you obtained together with this documentation.

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
* [Getting started with building single apps](530_single-apps.html)
* [Information needed for the development of multiple apps](540_multiple-apps.html)
