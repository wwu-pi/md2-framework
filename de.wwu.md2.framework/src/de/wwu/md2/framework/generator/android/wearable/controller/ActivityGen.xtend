package de.wwu.md2.framework.generator.android.wearable.controller

import de.wwu.md2.framework.generator.IExtendedFileSystemAccess
import de.wwu.md2.framework.generator.android.wearable.Settings
import de.wwu.md2.framework.generator.android.lollipop.util.MD2AndroidLollipopUtil
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ActionDrawer
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.Label
import de.wwu.md2.framework.mD2.TextInput
import de.wwu.md2.framework.mD2.ViewElementType
import de.wwu.md2.framework.mD2.ViewGUIElementReference
import de.wwu.md2.framework.mD2.WorkflowElementReference
import de.wwu.md2.framework.mD2.ContentContainer
import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.SensorType
import de.wwu.md2.framework.mD2.impl.GridLayoutPaneImpl
import de.wwu.md2.framework.generator.android.wearable.view.ValueGen

import de.wwu.md2.framework.mD2.ListView
import de.wwu.md2.framework.mD2.App

import de.wwu.md2.framework.services.MD2GrammarAccess.SensorTypeParamElements
import de.wwu.md2.framework.mD2.impl.SensorTypeImpl
import de.wwu.md2.framework.mD2.impl.SensorTypeParamImpl
import de.wwu.md2.framework.mD2.impl.SimpleTypeImpl
import de.wwu.md2.framework.mD2.SensorTypeParam
import java.util.List
import de.wwu.md2.framework.mD2.AttrSensorTyp
import de.wwu.md2.framework.mD2.impl.AttrSensorTypImpl
import de.wwu.md2.framework.mD2.AttrSensorAxis
import java.util.LinkedHashSet
import java.util.LinkedList
import java.util.Map
import de.wwu.md2.framework.mD2.IntegerInput
import java.awt.GridBagLayout
import de.wwu.md2.framework.mD2.FlowLayoutPane
import de.wwu.md2.framework.mD2.impl.FlowLayoutPaneImpl
import de.wwu.md2.framework.mD2.impl.ListViewImpl
import de.wwu.md2.framework.mD2.ViewIcon
import de.wwu.md2.framework.mD2.ListViewLayoutParam

class ActivityGen {

	static boolean FirstCall = true;

	def static generateActivities(IExtendedFileSystemAccess fsa, String rootFolder, String mainPath, String mainPackage,
		Iterable<ContainerElement> rootViews, Iterable<WorkflowElementReference> startableWorkflowElements, Iterable<Entity> entities, App app) {

		fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "NavigationAdapter.java",
			generateNavigationAdapter(mainPackage, startableWorkflowElements, rootViews))

		//fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + "StartActivity.java",
			//	generateStartActivity(mainPackage, startableWorkflowElements,  entities))

		rootViews.forEach [ rv |
			fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + rv.name + "Activity.java",
				generateActivity(mainPackage, rv, entities, FirstCall))

				if (rv instanceof ListView){
				fsa.generateFile(rootFolder + Settings.JAVA_PATH + mainPath + rv.name + "ListAdapter.java",
				generateListAdapter(mainPackage, rv, app))
				}

				//FirstCall=false;
		]
		FirstCall=true;
	}

		//generiert ListAdapter für Inhalt einer Listenansicht
		def static generateListAdapter(String mainPackage, ListView rv, App app)'''
		//generated in de.wwu.md2.framework.generator.android.wearable.controller.Activity.generateListAdapter()

		package «mainPackage»;
		
		import android.content.Context;
		import android.graphics.Color;
		import android.graphics.Point;
		import android.view.Display;
		import android.view.Gravity;
		import android.view.WindowManager;
		import android.support.v7.widget.RecyclerView;
		import android.view.View;
		import android.view.ViewGroup;
		import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2ButtonOnSwipeHandler;
		import de.uni_muenster.wi.md2library.controller.eventhandler.implementation.Md2OnClickHandler;
		import de.uni_muenster.wi.md2library.view.widgets.implementation.Md2Button;
		import de.uni_muenster.wi.md2library.controller.action.interfaces.Md2Action;
		import de.uni_muenster.wi.md2library.model.contentProvider.implementation.Md2ContentProviderRegistry;
		import de.uni_muenster.wi.md2library.model.contentProvider.interfaces.Md2ContentProvider;
		import de.uni_muenster.wi.md2library.model.contentProvider.interfaces.Md2MultiContentProvider;
		import de.uni_muenster.wi.md2library.controller.action.implementation.Md2UpdateListIndexAction;
		import de.uni_muenster.wi.md2library.controller.action.implementation.Md2RefreshListAction;
		
		«IF(!(rv.onClickAction === null))»
			import «mainPackage».md2.controller.action.«MD2AndroidLollipopUtil.getQualifiedNameAsString(rv.onClickAction, "_").toFirstUpper»_Action;
		«ENDIF»
		«IF(!(rv.leftSwipeAction === null))»
			import «mainPackage».md2.controller.action.«MD2AndroidLollipopUtil.getQualifiedNameAsString(rv.leftSwipeAction, "_").toFirstUpper»_Action;
		«ENDIF»
		«IF(!(rv.rightSwipeAction === null))»
			import «mainPackage».md2.controller.action.«MD2AndroidLollipopUtil.getQualifiedNameAsString(rv.rightSwipeAction, "_").toFirstUpper»_Action;
		«ENDIF»
		
		public class «rv.name»ListAdapter extends RecyclerView.Adapter{
			
			private Md2MultiContentProvider content;
			private Md2ButtonOnSwipeHandler swipeHandler;
			private Md2OnClickHandler clickHandler;
			
			public Md2ButtonOnSwipeHandler getOnSwipeHandler(){
				return swipeHandler;
			}
			
			public Md2OnClickHandler getOnClickHandler(){
				return clickHandler;
			}
			
			public «rv.name»ListAdapter(){
				content = Md2ContentProviderRegistry.getInstance().getContentMultiProvider("«rv.connectedProvider.contentProviderRef.name»");
				content.addAdapter(this, "«rv.name»ListAdapter");
				swipeHandler = new Md2ButtonOnSwipeHandler();
				clickHandler = new Md2OnClickHandler();
				«IF(!(rv.onClickAction === null))»
					Md2Action ca = new «MD2AndroidLollipopUtil.getQualifiedNameAsString(rv.onClickAction, "_").toFirstUpper»_Action();
					clickHandler.registerAction(ca);
				«ENDIF»
				«IF(!(rv.leftSwipeAction === null))»
					Md2Action lsa = new «MD2AndroidLollipopUtil.getQualifiedNameAsString(rv.leftSwipeAction, "_").toFirstUpper»_Action();
					swipeHandler.getLeftSwipeHandler().registerAction(lsa);
				«ENDIF»
				«IF(!(rv.rightSwipeAction === null))»
					Md2Action rsa = new «MD2AndroidLollipopUtil.getQualifiedNameAsString(rv.rightSwipeAction, "_").toFirstUpper»_Action();
					swipeHandler.getRightSwipeHandler().registerAction(rsa);
				«ENDIF»
			}
			
			@Override
			public void onBindViewHolder(RecyclerView.ViewHolder vh, int i){
				ListItem li = (ListItem) vh;
				if(content.getValue(i,"«rv.connectedProvider.tail.attributeRef.name»") != null){
					li.getButton().setText(content.getValue(i,"«rv.connectedProvider.tail.attributeRef.name»").getString().toString());
				} else {
					li.getButton().setText("Fehler");
				}
				//Listener hinzufügen
				Md2UpdateListIndexAction indexAction = new Md2UpdateListIndexAction("«rv.name»", i, content);
				Md2OnClickHandler ch = new Md2OnClickHandler();
				Md2ButtonOnSwipeHandler sw = new Md2ButtonOnSwipeHandler();
				ch.registerAction(indexAction);
				ch.addActions(clickHandler.getActions());
				sw.registerAction(indexAction, true);
				sw.registerAction(indexAction, false);
				sw.getLeftSwipeHandler().addActions(swipeHandler.getLeftSwipeHandler().getActions());
				sw.getRightSwipeHandler().addActions(swipeHandler.getRightSwipeHandler().getActions());
				Md2RefreshListAction rflaction = new Md2RefreshListAction(this);
				ch.registerAction(rflaction);
				sw.registerAction(rflaction, true);
				sw.registerAction(rflaction, false);
				li.getButton().setOnClickHandler(ch);
				li.getButton().setOnSwipeHandler(sw);
			}
			
			@Override
			public int getItemCount() {
				return content.getContents().size();
			}
			
			@Override
			public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup vg, int i){
				Md2Button b = new Md2Button (vg.getContext());
				ListItem li = new ListItem(b);
				return li;
			}
			
			public class ListItem extends RecyclerView.ViewHolder{
				
				private Md2Button button;
				
				public ListItem(View itemView){
					super(itemView);
					button = (Md2Button) itemView;
					button.setBackgroundColor(Color.TRANSPARENT);
					WindowManager wm = (WindowManager) «app.name.toFirstUpper».getAppContext().getSystemService(Context.WINDOW_SERVICE);
					Display display = wm.getDefaultDisplay();
					Point size = new Point();
					display.getSize(size);
					int width = size.x;
					button.setWidth(width);
					button.setGravity(Gravity.LEFT);
				}
				
				public Md2Button getButton(){
					return button;
				}
				
				
			}
			
		}
		
'''
		
		//generiert NavigationAdapter als Singleton, ersetzt die urspr«ngliche StartActivity
		//startActions werden in Konstruktor »bergeben
	def static generateNavigationAdapter(String mainPackage, Iterable<WorkflowElementReference> startableWorkflowElements, Iterable<ContainerElement> rootViews)'''
		// generated in de.wwu.md2.framework.generator.android.wearable.controller.Activity.generateStartActivity()
				package «mainPackage»;
				
				import android.graphics.drawable.Drawable;
				import android.support.wearable.view.drawer.WearableNavigationDrawer;
				import de.uni_muenster.wi.md2library.controller.action.interfaces.Md2Action;
				import de.uni_muenster.wi.md2library.view.management.implementation.Md2ViewManager;
				import java.util.ArrayList;
				«FOR wer : startableWorkflowElements»		        	
					import «mainPackage».md2.controller.action.«wer.workflowElementReference.name.toFirstUpper»___«wer.workflowElementReference.name.toFirstUpper»_startupAction_Action;
				«ENDFOR»
				
				public class NavigationAdapter extends WearableNavigationDrawer.WearableNavigationDrawerAdapter{
					
					private static NavigationAdapter instance;
					private int active;
					private int selected;
					private ArrayList<String> names;
					private ArrayList<Md2Action> actions;
					private boolean isFirstStart;
					
					
					public static synchronized NavigationAdapter getInstance(){
					        if (NavigationAdapter.instance == null) {
					            NavigationAdapter.instance = new NavigationAdapter();
					        }
					        return instance;
					}
					
					private NavigationAdapter(){
						active = 0;
						selected = 0;
						isFirstStart = true;
						names = new ArrayList<String>();
						actions = new ArrayList<Md2Action>();
						«FOR wer : startableWorkflowElements»
							names.add("«wer.workflowElementReference.name.toFirstUpper»");
							actions.add(new «wer.workflowElementReference.name.toFirstUpper»___«wer.workflowElementReference.name.toFirstUpper»_startupAction_Action());
						«ENDFOR»
					}
					
					@Override
					public int getCount() {
						return actions.size();
					}
					
					@Override
					public void onItemSelected(int position) {
						selected = position;
					}
					
					@Override
					public String getItemText(int pos) {
						return names.get(pos);
					}
					
					@Override
					public Drawable getItemDrawable(int position) {
						«println(generateIcons(rootViews))»
					}
					
					public int getActive(){
						return active;
					}
					
					public int getSelected(){
						return selected;
					}
					
					public void maybeFirstStart(){
						if(isFirstStart){
							actions.get(0).execute();
							isFirstStart = false;
						}
					}
					
					public boolean close(){
						if (active != selected){
							active = selected;
							actions.get(active).execute();
							return true;
						} else {
							return false;
						}
					}
					
				}
				
			'''
	def private static String generateIcons(Iterable<ContainerElement> rootViews){
		var String result = "switch(position){"
		var viewnumber = 0;
		
		for (rv : rootViews) {
			switch (rv) {
				GridLayoutPaneImpl: {
					for (rve : (rv as GridLayoutPaneImpl).params) {
						if(rve instanceof ViewIcon){
							result += "\r\n case " + viewnumber + ":";
							result += "\r\n return Md2ViewManager.getInstance().getActiveView().getDrawable(R.drawable."+(rve as ViewIcon).value+");"
						}		
					}
				}
				FlowLayoutPaneImpl: {
					for (rve : (rv as FlowLayoutPaneImpl).params) {
						if(rve instanceof ViewIcon){
							result += "\r\n case " + viewnumber + ":";
							result += "\r\n return Md2ViewManager.getInstance().getActiveView().getDrawable(R.drawable."+(rve as ViewIcon).value+");"
						}		
					}
				}
				ListViewImpl: {
				for (rve : rv.params) {
					println("RVE ListView:" + rve);
						if(rve instanceof ViewIcon){
							result += "\r\n case " + viewnumber + ":";
							result += "\r\n return Md2ViewManager.getInstance().getActiveView().getDrawable(R.drawable."+(rve as ViewIcon).value+");"
						}		
					}
				}
				default: {
					println("Kein GridLayoutPane")
				}
			}

			viewnumber++;
		}
		
		result+="\r\ndefault:\r\n return Md2ViewManager.getInstance().getActiveView().getDrawable(R.mipmap.ic_launcher);}"
		return result;
	}
	
	def static generateStartActivity(String mainPackage, Iterable<WorkflowElementReference> startableWorkflowElements, Iterable<Entity> entities)'''
		// generated in de.wwu.md2.framework.generator.android.wearable.controller.Activity.generateStartActivity()
		package «mainPackage»;

		import android.os.Bundle;
		import android.app.Activity;
		import android.content.Intent;

		import android.view.View;

		//Sensoren
		import android.hardware.Sensor;
		import android.hardware.SensorEvent;
		import android.hardware.SensorEventListener;
		import android.hardware.SensorManager;

		import «mainPackage».md2.controller.Controller;
		import «Settings.MD2LIBRARY_VIEWMANAGER_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_WIDGETREGISTRY_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_TASKQUEUE_PACKAGE_NAME»;
		«MD2AndroidLollipopUtil.generateImportAllWidgets»
		«MD2AndroidLollipopUtil.generateImportAllTypes»
		«MD2AndroidLollipopUtil.generateImportAllEventHandler»

		«FOR wer : startableWorkflowElements»
			import «mainPackage».md2.controller.action.«wer.workflowElementReference.name.toFirstUpper»___«wer.workflowElementReference.name.toFirstUpper»_startupAction_Action;
		«ENDFOR»

		import «Settings.MD2LIBRARY_PACKAGE»controller.action.implementation.Md2GoToViewAction;
		import «Settings.MD2LIBRARY_PACKAGE»SensorHelper;

		public class StartActivity extends Activity {


		    @Override
		    protected void onCreate(Bundle savedInstanceState) {
		        super.onCreate(savedInstanceState);
		        setContentView(R.layout.activity_start);
		        «FOR wer : startableWorkflowElements»
		        	Md2Button «wer.workflowElementReference.name»Button = (Md2Button) findViewById(R.id.startActivity_«wer.workflowElementReference.name»Button);
		        	«wer.workflowElementReference.name»Button.setWidgetId(R.id.startActivity_«wer.workflowElementReference.name»Button);
		        	Md2WidgetRegistry.getInstance().addWidget(«wer.workflowElementReference.name»Button);
		        «ENDFOR»
		    }

		    @Override
		    protected void onStart(){
				super.onStart();
				Md2ViewManager.getInstance().setActiveView(this);

		        // TODO move startableWorkflowElements to Md2WorkflowManager
				«FOR wer : startableWorkflowElements»
					Md2Button «wer.workflowElementReference.name»Button = (Md2Button) findViewById(R.id.startActivity_«wer.workflowElementReference.name»Button);
					«wer.workflowElementReference.name»Button.getOnClickHandler().registerAction(new «wer.workflowElementReference.name.toFirstUpper»___«wer.workflowElementReference.name.toFirstUpper»_startupAction_Action());
		        «ENDFOR»

		        }
				Md2TaskQueue.getInstance().tryExecutePendingTasks();
		    }

			@Override
		    protected void onPause(){
		        super.onPause();
			«FOR wer : startableWorkflowElements»
				Md2Button «wer.workflowElementReference.name»Button = (Md2Button) findViewById(R.id.startActivity_«wer.workflowElementReference.name»Button);
				Md2WidgetRegistry.getInstance().saveWidget(«wer.workflowElementReference.name»Button);
			«ENDFOR»
		    }

		    @Override
			public void onBackPressed() {
				// remain on start screen
			}
		}
	'''

	private def static generateActivity(String mainPackage, ContainerElement rv, Iterable<Entity> entities, boolean FirstCall) '''
		// generated in de.wwu.md2.framework.generator.android.wearable.controller.Activity.generateActivity()
		package «mainPackage»;

		import android.app.Activity;
		import android.content.Intent;
		import android.os.Bundle;
		import android.os.Handler;
		import android.view.View;
		import android.view.Gravity;
		import android.support.wearable.activity.WearableActivity;
		import android.support.wearable.view.drawer.WearableDrawerLayout;
		import android.support.wearable.view.drawer.WearableDrawerView;
		import android.support.wearable.view.drawer.WearableNavigationDrawer;

		import android.support.wearable.view.drawer.WearableActionDrawer;
		import android.graphics.drawable.Drawable;
		import android.view.MenuItem;

		import android.support.wearable.view.CurvedChildLayoutManager;
		import android.support.wearable.view.WearableRecyclerView;


		import «mainPackage».md2.controller.Controller;
		import «Settings.MD2LIBRARY_VIEWMANAGER_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_WIDGETREGISTRY_PACKAGE_NAME»;
		import «Settings.MD2LIBRARY_TASKQUEUE_PACKAGE_NAME»;
		«MD2AndroidLollipopUtil.generateImportAllWidgets»
		«MD2AndroidLollipopUtil.generateImportAllTypes»
		«MD2AndroidLollipopUtil.generateImportAllEventHandler»
		
		import de.uni_muenster.wi.md2library.controller.action.interfaces.Md2Action;

		«FOR viewElement: rv.eAllContents.toIterable»
			«IF viewElement instanceof ActionDrawer»
				«IF(viewElement.onItemClickAction !== null)»
					«FOR itemClickAction: viewElement.onItemClickAction»
						import «mainPackage».md2.controller.action.«MD2AndroidLollipopUtil.getQualifiedNameAsString(itemClickAction, "_")»_Action;
					«ENDFOR»
				«ENDIF»
			«ENDIF»
		«ENDFOR»



		import «Settings.MD2LIBRARY_PACKAGE»SensorHelper;


		public class «rv.name»Activity extends WearableActivity implements WearableActionDrawer.OnMenuItemClickListener {

			private WearableDrawerLayout drawerLayout;
			private WearableNavigationDrawer navigationDrawer;
			private NavigationAdapter adapter;
			private WearableActionDrawer actionDrawer;
			private WearableRecyclerView wrv;
			public Md2OnClickHandler clickHandler;

		    @Override
		    protected void onCreate(Bundle savedInstanceState) {
		        super.onCreate(savedInstanceState);
		        setContentView(R.layout.activity_«rv.name.toLowerCase»);

		        clickHandler = new Md2OnClickHandler();

		        «FOR viewElement: rv.eAllContents.filter(ViewElementType).toIterable»
		        	«IF !(viewElement instanceof ActionDrawer)»
		        		«generateAddViewElement(viewElement)»
		        	«ENDIF»
		        «ENDFOR»

	     		drawerLayout = (WearableDrawerLayout) findViewById(R.id.drawer_layout_«rv.name»);
	        	drawerLayout.setDrawerStateCallback(new WearableDrawerLayout.DrawerStateCallback() {
	           		@Override
	            	public void onDrawerOpened(View view) {
	            		navigationDrawer.setCurrentItem(adapter.getActive(), true);
	            	}
	            	@Override
	            	public void onDrawerClosed(View view) {
	                	if(adapter.close()){
	                		«rv.name»Activity.this.finish();
	                	}
	            	}
	            	@Override
	            	public void onDrawerStateChanged(@WearableDrawerView.DrawerState int i) {
	            		if(i == 0){
	            		   if(navigationDrawer.isPeeking()) {
	            		   		final Handler handler = new Handler();
	            		   		handler.postDelayed(new Runnable() {
	            		   			@Override
	            		   			public void run() {
	            		   				if(navigationDrawer.isPeeking()){
	            		   					navigationDrawer.closeDrawer();
	            		   				}
	            	 			    }
	            		   		 }, 2000);
	            		    }
	            		    «FOR viewElement: rv.eAllContents.toIterable»
	            		    «IF viewElement instanceof ActionDrawer»
	            		    if(actionDrawer.isPeeking()){
	            				final Handler handler = new Handler();
	            		   		handler.postDelayed(new Runnable() {
	        						 @Override
	           						 public void run() {
	            						  if(actionDrawer.isPeeking()){
	            		   						actionDrawer.closeDrawer();
	            		   					}
	            		   			  }
	            		   		 }, 2000);
	            		    }
	            		   	«ENDIF»
	           				«ENDFOR» 
                          }
                       }
	        	});


		        navigationDrawer = (WearableNavigationDrawer) findViewById(R.id.navigation_drawer_«rv.name»);
		        adapter = NavigationAdapter.getInstance();
		        navigationDrawer.setAdapter(adapter);


		        «FOR viewElement: rv.eAllContents.toIterable»
					«IF viewElement instanceof ActionDrawer»
						actionDrawer = (WearableActionDrawer) findViewById(R.id.bottom_action_drawer_«rv.name»);
						actionDrawer.setOnMenuItemClickListener(this);
					«ENDIF»
				«ENDFOR»


		        navigationDrawer.setCurrentItem(adapter.getActive(), true);

				«IF (rv instanceof ListView)»
				wrv = (WearableRecyclerView) findViewById(R.id.wearable_recycler_view_«rv.name»);
									    	«rv.name»ListAdapter listAdapter = new «rv.name»ListAdapter();
										   	wrv.setAdapter(listAdapter);
									    	wrv.setCenterEdgeItems(true);
									    	CurvedChildLayoutManager clm = new CurvedChildLayoutManager(this);
									    	wrv.setLayoutManager(clm);
				«ENDIF»


			«IF FirstCall»
				//HardwareSensoren
				«generateSensor(entities)»
			«ENDIF»

		    }

		    @Override
		    protected void onStart(){
				super.onStart();
		        Md2ViewManager.getInstance().setActiveView(this);

		        «FOR viewElement: rv.eAllContents.filter(ViewElementType).toIterable»
		        	«IF !(viewElement instanceof ActionDrawer)»
		        		«generateLoadViewElement(viewElement)»
		        	«ENDIF»
		        «ENDFOR»

		        drawerLayout.peekDrawer(Gravity.TOP);
		        drawerLayout.peekDrawer(Gravity.BOTTOM);

		        adapter.maybeFirstStart();


		        Md2TaskQueue.getInstance().tryExecutePendingTasks();


		    }

			@Override
		    protected void onPause(){
		        super.onPause();
		        «FOR viewElement: rv.eAllContents.filter(ViewElementType).toIterable»
		        	«IF !(viewElement instanceof ActionDrawer)»
		        		«generateSaveViewElement(viewElement)»
		        	«ENDIF»
		        «ENDFOR»
		    }
		    
		    @Override
		    protected void onResume(){
		    	super.onResume();
		    }
		    
		    @Override
		    protected void onDestroy(){
		    	super.onDestroy();
		    	«FOR viewElement: rv.eAllContents.filter(ViewElementType).toIterable»
		    		«IF !(viewElement instanceof ActionDrawer)»
		    			«generateSaveViewElement(viewElement)»
		 	       	«ENDIF»
		       «ENDFOR»
		    }

		    @Override
			public void onBackPressed() {
				// go back to start screen
				Md2ViewManager.getInstance().goTo(getString(R.string.StartActivity));
			}

			@Override
			public boolean onMenuItemClick(MenuItem menuItem) {
			
			
			«var int z = 0»
			«FOR viewElement: rv.eAllContents.toIterable»
				«IF viewElement instanceof ActionDrawer»
					«IF(z++ == 0)»
					«ENDIF»
					«IF(viewElement.onItemClickAction !== null)»

						Md2Action ca = null;

						final int itemId = menuItem.getItemId();

						switch(itemId) {
							«var ElementCounter = 0»
							«FOR itemClickAction: viewElement.onItemClickAction»
								case R.id.«itemClickAction.name»_item«ElementCounter++»:
									ca = new «MD2AndroidLollipopUtil.getQualifiedNameAsString(itemClickAction, "_").toFirstUpper»_Action();
									break;

							«ENDFOR»
						}

						clickHandler.registerAction(ca);

						try {
							ca.execute();

							return true;
						}catch(Exception e) {
							return false;
						}
					«ENDIF»
				«ENDIF»
			«ENDFOR»
			«IF (z == 0)»
				return true;
			«ENDIF»
			}
		}
	'''

	private static def String generateAddViewElement(ViewElementType vet){
		if (vet instanceof Label && vet.eContainer() instanceof ContentContainer && (vet.eContainer() as ContentContainer).elements.filter(Label).findFirst[label | label.name.startsWith("_title")] !== null && (vet.eContainer() as ContentContainer).elements.filter(Label).findFirst[label | label.name.startsWith("_title")].equals(vet)) {
			return "" // Skip title label
		}

		var String result = ""
		var String type = ""

		var qualifiedName = MD2AndroidLollipopUtil.getQualifiedNameAsString(vet, "_")
		if(qualifiedName === null || qualifiedName.empty)
			return ""

		switch vet{
			ViewGUIElementReference: return generateSaveViewElement(vet.value)
			default: type = getCustomViewTypeNameForViewElementType(vet)
		}

		if(type === null || type.empty)
			return ""

		result = '''
			«type» «qualifiedName.toFirstLower» = («type») findViewById(R.id.«qualifiedName»);
			«qualifiedName.toFirstLower».setWidgetId(R.id.«qualifiedName»);
			Md2WidgetRegistry.getInstance().addWidget(«qualifiedName.toFirstLower»);
        '''
        return result
	}

	private static def String generateLoadViewElement(ViewElementType vet){
		if (vet instanceof Label && vet.eContainer() instanceof ContentContainer && (vet.eContainer() as ContentContainer).elements.filter(Label).findFirst[label | label.name.startsWith("_title")] !== null && (vet.eContainer() as ContentContainer).elements.filter(Label).findFirst[label | label.name.startsWith("_title")].equals(vet)) {
			return "" // Skip title label
		}

		var String result = ""
		var String type = ""

		var qualifiedName = MD2AndroidLollipopUtil.getQualifiedNameAsString(vet, "_")
		if(qualifiedName === null || qualifiedName.empty)
			return ""

		switch vet{
			ViewGUIElementReference: return generateSaveViewElement(vet.value)
			default: type = getCustomViewTypeNameForViewElementType(vet)
		}

		if(type === null || type.empty)
			return ""

		result = '''
			«type» «qualifiedName.toFirstLower» = («type») findViewById(R.id.«qualifiedName»);
			Md2WidgetRegistry.getInstance().loadWidget(«qualifiedName.toFirstLower»);
        '''

		return result
	}

	private static def String generateSaveViewElement(ViewElementType vet){
		if (vet instanceof Label && vet.eContainer() instanceof ContentContainer && (vet.eContainer() as ContentContainer).elements.filter(Label).findFirst[label | label.name.startsWith("_title")] !== null && (vet.eContainer() as ContentContainer).elements.filter(Label).findFirst[label | label.name.startsWith("_title")].equals(vet)) {
			return "" // Skip title label
		}

		var String result = ""
		var String type = ""

		var qualifiedName = MD2AndroidLollipopUtil.getQualifiedNameAsString(vet, "_")
		if(qualifiedName === null || qualifiedName.empty)
			return ""

		switch vet{
			ViewGUIElementReference: return generateSaveViewElement(vet.value)
			default: type = getCustomViewTypeNameForViewElementType(vet)
		}

		if(type === null || type.empty)
			return ""

		result = '''
			«type» «qualifiedName.toFirstLower» = («type») findViewById(R.id.«qualifiedName»);
			Md2WidgetRegistry.getInstance().saveWidget(«qualifiedName.toFirstLower»);
        '''

		return result
	}

	private static def String getCustomViewTypeNameForViewElementType(ViewElementType vet){
		switch vet{
			ViewGUIElementReference: return generateSaveViewElement(vet.value)
			GridLayoutPane:
				return "Md2GridLayoutPane"
			Button:
				return "Md2Button"
			Label:
				return "Md2Label"
			TextInput:
				return "Md2TextInput"
			IntegerInput:
				return "Md2TextInput"
			default: return ""
		}
	}

	/**
	 * generateSensor erwatet die Entites aus dem MD2 Modell, um daraus die entsprechenden
	 * Attribute, die als Sensor, gekenzeichnet sind zu generieren. Der fertig generierte Code
	 * wird als String zurückgegeben.
	 */
	private static def String generateSensor(Iterable<Entity> entities){
		var String result = "";
		//Alle Entities durchgehen
		for (e : entities) {
			for (attribute : e.attributes){
				//Nur Attribute vom Typ Sensor bearbeiten
				if(attribute.type instanceof SensorType){
					//Parameter durchgehen
					for(param : (attribute.type as SensorType).params){
						//Parameter vom AttrSensorTyp
						if(param instanceof AttrSensorTyp){
							if(param.accelerometer){
								result += ("SensorHelper meinSensorHelper_" + attribute.name +" = new SensorHelper(this, \"" + attribute.name + "\", \"accelerometer\", \"");
							}
							if(param.gyroskop){
								result += ("SensorHelper meinSensorHelper_" + attribute.name +" = new SensorHelper(this, \"" + attribute.name + "\", \"gyroskop\", \"")
							}
							if(param.heartrate){
								result += ("SensorHelper meinSensorHelper_" + attribute.name +" = new SensorHelper(this, \"" + attribute.name + "\", \"heartrate\");\r\n")
							}
							if(param.proximity){
								result += ("SensorHelper meinSensorHelper_" + attribute.name +" = new SensorHelper(this, \"" + attribute.name + "\", \"proximity\");\r\n")
							}
						}
						//Parameter vom AttrSensorAxis
						if(param instanceof AttrSensorAxis){
							if(param.x){result += ("X\");\r\n")}
							if(param.y){result += ("Y\");\r\n")}
							if(param.z){result += ("Z\");\r\n")}
						}
					}
				}
			}
			println(result)
			return result;
		}
	}
}
