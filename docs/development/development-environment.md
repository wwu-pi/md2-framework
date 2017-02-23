Development Environment
=======================

TODO bring up-to-date 

Development of MD² is known to work with the following set of tools and dependencies.
Newer or older versions may work as well.

* [Eclipse IDE for Java and DSL Developers (Juno SR2)](http://www.eclipse.org/downloads/packages/eclipse-ide-java-and-dsl-developers/junosr2) (Eclipse 4.2.2)
* [Xtext](http://www.xtext.org) 2.4.1
* [Xtend](http://www.xtend.org) 2.4.1
* For Android development: [Android SDK](http://developer.android.com/sdk/index.html) 22.0.1
* For iOS development: [Xcode](http://developer.apple.com/tools/xcode/) 4.6.2 (requires Mac OS X 10.8)

Set-up
------

1. Extract the Eclipse IDE zip file obtained from the site mentioned above.
2. Start Eclipse.
3. Update Xtext and Xtend to version 2.4.1
	* Choose Help > Install New Software.
	* Add (or select) update site for URL http://download.eclipse.org/modeling/tmf/xtext/updates/composite/releases/.
	* Select Xtend-2.4.1 and Xtext-2.4.1 and install them.
4. (optional) Install the Android Developer Tools plugin for Eclipse as document at http://developer.android.com/sdk/installing/installing-adt.html.
5. (recommended) Set the default encoding of the workspace to "UTF-8" and default line endings to "Unix" (Window > Preferences, category General > Workspace).

Further information
-------------------

* [Getting Started with Development](getting-started-dev.md)
* [Developing MD2 for iOS – Particularities](md2-ios-development.md)
