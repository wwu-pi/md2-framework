Getting Started with Development
================================

This guide briefly sketches how to get started with developing MD2. It assumes that the [development environment has been set up](development-environment.md)

1. Clone the framework repository (URLs available from https://github.com/wwu-pi/md2-framework), either from within Eclipse or separately.
	In the latter case, add your cloned repo manually to the list of Git Repositories in Eclipse's Git perspective.
2. In Eclipse, select the just cloned repository and choose "Import Projects..." from the context-menu.
3. Select "Import existing projects" and Next. On the next page, select at least all projects whose names begin with `de.wwu.md2.framework` and finish the dialog.
4. Generate the Xtext artifacts from the description of MD2's language: Select or open the MD2.xtext file and run it as "Generate Xtext Artifacts". Look out for any prompts on the console and answer yes (`y`) if asked to download ANTLR.
   * It may be necessary to increase the memory available to this run configuration: select the corresponding run configuration, switch to the "Arguments" tab and enter `-Xmx256M` as a "VM argument". 
5. Clean the MD2 projects (Project > Clean...) to trigger a full rebuild, which should resolve all remaining errors.
6. Select the main project `de.wwu.md2.framework` and run it as an "Eclipse Application" in order to start a new Eclipse instance that contains the MD2 plugins.

Development should happen in the original Eclipse instance, mostly in the `src` folder of the project `de.wwu.md2.framework`.
