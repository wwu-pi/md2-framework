package de.wwu.md2.framework;

import org.eclipse.xtext.conversion.IValueConverterService;
import org.eclipse.xtext.scoping.impl.ImportedNamespaceAwareLocalScopeProvider;

import com.google.inject.Binder;
import com.google.inject.multibindings.Multibinder;
import com.google.inject.name.Names;

import de.wwu.md2.framework.conversion.MD2ValueConverterService;
import de.wwu.md2.framework.generator.IPlatformGenerator;
import de.wwu.md2.framework.generator.TestGenerator;
//import de.wwu.md2.framework.generator.android.AndroidGenerator;
import de.wwu.md2.framework.generator.backend.BackendGenerator;
//import de.wwu.md2.framework.generator.ios.IOSGenerator;
import de.wwu.md2.framework.generator.mapapps.MapAppsGenerator;
import de.wwu.md2.framework.scoping.MD2ImportedNamespaceAwareLocalScopeProvider;

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
public class MD2RuntimeModule extends de.wwu.md2.framework.AbstractMD2RuntimeModule {
	
	@Override
	public void configure(Binder binder) {
		super.configure(binder);
		Multibinder<IPlatformGenerator> multiGenBinder = Multibinder.newSetBinder(binder, IPlatformGenerator.class);
		
		// Bind all generators here
		//multiGenBinder.addBinding().to(AndroidGenerator.class);
		//multiGenBinder.addBinding().to(IOSGenerator.class);
		multiGenBinder.addBinding().to(BackendGenerator.class);
		//multiGenBinder.addBinding().to(TestGenerator.class);
		multiGenBinder.addBinding().to(MapAppsGenerator.class);
		
		binder.bind(Boolean.class).annotatedWith(Names.named("Debug MD2GeneratorUtil")).toInstance(true);
	}
	
	public Class<? extends ImportedNamespaceAwareLocalScopeProvider> bindImportedNamespaceAwareLocalScopeProvider() {
		return MD2ImportedNamespaceAwareLocalScopeProvider.class;
	}
	
	@Override
	public Class<? extends IValueConverterService> bindIValueConverterService() {
		return MD2ValueConverterService.class;
	}
	
	public Class<? extends org.eclipse.xtext.generator.IGenerator> bindIGenerator() {
		// the IGenerator interface is not used anymore. However, org.eclipse.xtext.builder.BuilderParticipant injects
		// an IGenerator implementation (that is never used, because the according methods are overwritten) and thus Guice
		// needs any binding. Just provide any implementing class here to make Guice happy...
		return TestGenerator.class;
	}
	
}
