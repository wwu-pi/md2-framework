/*
 * generated by Xtext 2.13.0
 */
package de.wwu.md2.framework


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class MD2StandaloneSetup extends MD2StandaloneSetupGenerated {

	def static void doSetup() {
		new MD2StandaloneSetup().createInjectorAndDoEMFRegistration()
	}
}
