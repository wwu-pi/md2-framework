package de.wwu.md2.framework;

/**
 * Initialization support for running Xtext languages 
 * without equinox extension registry
 */
public class MD2StandaloneSetup extends MD2StandaloneSetupGenerated {

	public static void doSetup() {
		new MD2StandaloneSetup().createInjectorAndDoEMFRegistration();
	}
	
}
