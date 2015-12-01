package de.wwu.md2.framework.generator.android

import de.wwu.md2.framework.generator.android.util.JavaClassDef
import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ContentProvider
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.Enum
import de.wwu.md2.framework.mD2.ReferencedModelType
import java.util.Set

import static de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*

class ContentProviderClass {
	val DataContainer dataContainer
	val ContentProvider contentProvider
	val Entity entity
	val ContainerElement mainActivity
	val Set<Enum> enums
	
	new(DataContainer dataContainer, ContainerElement mainActivity, de.wwu.md2.framework.mD2.ContentProvider contentProvider) {
		this.dataContainer = dataContainer;
		this.contentProvider = contentProvider
		this.entity = (contentProvider.type as ReferencedModelType).entity as Entity;
		this.mainActivity = mainActivity
		this.enums = dataContainer.models.map([it.modelElements]).flatten.filter(typeof(Enum)).toSet
	}
	
	def generateContentProvider(JavaClassDef classDef) '''
		«classDef.simpleName = contentProvider.name»
		«val entityType = entity.name»
		«val typeRefName = '''«entity.name»«if (contentProvider.type.many) ".Array"»'''»
		«val parentClass = if (contentProvider.local) "LocalContentProvider" else { if (contentProvider.type.many) "RemoteManyContentProvider" else "RemoteContentProvider" }»
		«val remoteConnection = if (contentProvider.connection != null) contentProvider.connection else dataContainer.main.defaultConnection»
		package «classDef.fullPackage»;
		
		import java.util.List;
		import java.util.Date;
		
		import org.codehaus.jackson.Version;
		import org.codehaus.jackson.map.module.SimpleModule;
		import org.codehaus.jackson.type.TypeReference;
		
		import android.widget.TextView;

		import de.wwu.md2.android.lib.MD2Application;
		import de.wwu.md2.android.lib.controller.actions.CodeFragment;
		import de.wwu.md2.android.lib.controller.actions.CustomAction;
		import de.wwu.md2.android.lib.controller.contentprovider.«parentClass»;
		import de.wwu.md2.android.lib.controller.contentprovider.MD2DateSerializer;
		import de.wwu.md2.android.lib.controller.contentprovider.MD2EnumDeserializer;
		import de.wwu.md2.android.lib.controller.contentprovider.MD2EnumSerializer;
		import «classDef.basePackage».R;
		import «classDef.basePackage».models.«entity.name»;
		«FOR md2Enum : enums»
			import «classDef.basePackage».models.«md2Enum.name»;
		«ENDFOR»
		
		@SuppressWarnings("all")
		public class «classDef.simpleName» extends «parentClass»<«entityType»> {
			
			public «classDef.simpleName»(MD2Application app) {
				super(app, new TypeReference<«typeRefName»>() {}, «entityType».class, «contentProvider.type.many»,
				«IF contentProvider.local» 
				"«contentProvider.name».json"
				«ELSE»
				"«remoteConnection.uri»"
				«ENDIF»
				);
				
				SimpleModule module = new SimpleModule("MyModule", new Version(1, 0, 0, null));
				«FOR md2Enum : enums»
					module.addDeserializer(«md2Enum.name».class, new MD2EnumDeserializer<«md2Enum.name»>(«md2Enum.name».class));
					module.addSerializer(«md2Enum.name».class, new MD2EnumSerializer());
				«ENDFOR»
				module.addSerializer(Date.class, new MD2DateSerializer());
				om.registerModule(module);
				
				final «classDef.simpleName» cp = this;
				new CustomAction(app) {
					
					@Override
					protected void initializeCodeFragments() {
						addCodeFragment(new CodeFragment() {
							
							@Override
							public String getActivityName() {
								return "«getName(mainActivity).toFirstUpper»Activity";
							}
							
							@Override
							public void execute(MD2Application app) {
								cp.open();
							}
						});
					}
				}.execute();
			}
			
			«IF !contentProvider.local» 
				«val filter = generateRemoteFilterString(contentProvider.whereClause, [
					'''\"" + ((TextView) app.getActiveActivity().findViewById(R.id.«getName(it)»)).getText() +"\"'''
				])»
				«IF filter != null»
					@Override
					protected String getFilter() {
						return "«filter»";
					}
				«ENDIF»
			«ENDIF»
		}
	'''
	
}