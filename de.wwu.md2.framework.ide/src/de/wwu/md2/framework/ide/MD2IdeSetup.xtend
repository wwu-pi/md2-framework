/*
 * generated by Xtext 2.13.0
 */
package de.wwu.md2.framework.ide

import com.google.inject.Guice
import de.wwu.md2.framework.MD2RuntimeModule
import de.wwu.md2.framework.MD2StandaloneSetup
import org.eclipse.xtext.util.Modules2

/**
 * Initialization support for running Xtext languages as language servers.
 */
class MD2IdeSetup extends MD2StandaloneSetup {

	override createInjector() {
		Guice.createInjector(Modules2.mixin(new MD2RuntimeModule, new MD2IdeModule))
	}
	
}