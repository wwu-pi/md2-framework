package de.wwu.md2.framework.generator.android

import de.wwu.md2.framework.generator.android.templates.StringsXmlTemplate
import de.wwu.md2.framework.generator.android.util.JavaClassDef
import de.wwu.md2.framework.generator.util.DataContainer
import de.wwu.md2.framework.mD2.Button
import de.wwu.md2.framework.mD2.CheckBox
import de.wwu.md2.framework.mD2.ContainerElement
import de.wwu.md2.framework.mD2.ContainerElementDef
import de.wwu.md2.framework.mD2.EntitySelector
import de.wwu.md2.framework.mD2.FlowLayoutPane
import de.wwu.md2.framework.mD2.GridLayoutPane
import de.wwu.md2.framework.mD2.OptionInput
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.TabbedAlternativesPane
import de.wwu.md2.framework.mD2.TextInput
import de.wwu.md2.framework.mD2.Tooltip
import de.wwu.md2.framework.mD2.ViewElement
import de.wwu.md2.framework.mD2.ViewElementDef
import de.wwu.md2.framework.mD2.ViewElementRef
import de.wwu.md2.framework.mD2.ViewElementType

import static de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import static de.wwu.md2.framework.mD2.TextInputType.*

class Activity {
	
	private DataContainer dataContainer
	
	new (DataContainer dataContainer) {
		this.dataContainer = dataContainer
	}
	
	/////////////////////////////////////////
	// General activity
	/////////////////////////////////////////
	
	def generateActivity(String basePackage, ContainerElement elem) '''
		«var elemName = getName(elem)»
		«if (elemName == null) elemName = elem.name»
		package «basePackage».controller;
		
		import android.app.Activity;
		import android.app.DialogFragment;
		import android.os.Bundle;
		import android.view.View;
		import android.view.View.OnClickListener;
		import android.widget.ArrayAdapter;
		import android.widget.Button;
		import android.widget.Spinner;
		import android.widget.TextView;
		import de.wwu.md2.android.lib.MD2Application;
		import de.wwu.md2.android.lib.controller.contentprovider.EntitySelectorHandler;
		import de.wwu.md2.android.lib.controller.events.MD2EventHandler;
		import de.wwu.md2.android.lib.controller.events.MD2FocusLeftEvent;
		import de.wwu.md2.android.lib.controller.events.MD2ItemSelectedEvent;
		import de.wwu.md2.android.lib.controller.events.MD2TouchEvent;
		import de.wwu.md2.android.lib.controller.validators.NotNullValidator;
		import de.wwu.md2.android.lib.view.DatePickerFragment;
		import de.wwu.md2.android.lib.view.DateTimePickerFragment;
		import de.wwu.md2.android.lib.view.MessageBoxFragment;
		import de.wwu.md2.android.lib.view.TimePickerFragment;
		import «basePackage».R;
		
		@SuppressWarnings("unused")
		public class «elemName.toFirstUpper»Activity extends Activity {
		
			@Override
			protected void onCreate(Bundle savedInstanceState) {
				super.onCreate(savedInstanceState);
				setContentView(R.layout.«elemName.toLowerCase»);
				
				// Initialize date and time pickers
				initializeDateTimePickers();
				
				// Initialize tool tips
				initializeToolTips();
				
				// Initialize event handling
				initializeEvents();
				
				// Initialize entity selectors
				initializeEntitySelectors();
			}
			
			@Override
		    public void onResume() {
		        super.onResume();
		        
				getApp().setActiveActivity("«elemName.toFirstUpper»", this);
		    }
			
			private void initializeDateTimePickers() {
				«generateDateTimePickerInitialization(elem, "")»
			}
			
			private void initializeToolTips() {
				«generateToolTipInitialization(elem, "")»
			}
			
			private void initializeEvents() {
				«generateEventInitialization(elem, "")»
			}
			
			private void initializeEntitySelectors() {
				«generateEntitySelectorsInitialization(elem, basePackage, "this", "")»
			}
			
			private MD2Application getApp() {
				return (MD2Application) getApplication();
			}
		}
	'''
	
	
	/////////////////////////////////////////
	// Tab activity
	/////////////////////////////////////////
	
	
	def generateTabbedActivity(String basePackage, StringsXmlTemplate strings, TabbedAlternativesPane pane) '''
		package «basePackage».controller;
		
		import java.util.ArrayList;
		import java.util.List;
		
		import android.app.ActionBar;
		import android.app.Activity;
		import android.view.Menu;
		import de.wwu.md2.android.lib.ChangeTabListener;
		import de.wwu.md2.android.lib.MD2Application;
		import de.wwu.md2.android.lib.view.TabbedActivity;
		import «basePackage».R;
		
		public class «getName(pane).toFirstUpper»Activity extends Activity implements TabbedActivity {
			
			private boolean isInitialized = false;
			private List<String> tabList;
			private int currentTab;
			
			@Override
			public boolean onCreateOptionsMenu(Menu menu) {
				if (!isInitialized) {
					// Check whether app object has to be reinitialized
					getApp().checkForReinitialization("«getName(pane).toFirstUpper»");
					getApp().setActiveActivity("«getName(pane).toFirstUpper»", this);
					initializeTabList();
					createActionBar(getActionBar());
					isInitialized = true;
				}
				return false;
			}
			
			private void initializeTabList() {
				tabList = new ArrayList<String>();
				«FOR tabContainer : pane.elements»
					tabList.add("«getName((tabContainer as ContainerElementDef).value)»");
				«ENDFOR»
			}
			
			@Override
			public void setSelectedTab(String tabName) {
				setSelectedTab(tabList.indexOf(tabName));
			}
			
			private void setSelectedTab(int index) {
				getActionBar().setSelectedNavigationItem(index);
			}
			
			@Override
			public void tabChanged() {
				currentTab = getActionBar().getSelectedNavigationIndex();
			}
		
			@Override
			public void cancelTabChange() {
				setSelectedTab(currentTab);
			}
			
			private void createActionBar(ActionBar bar) {
				bar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
				
				«FOR tabContainer : pane.elements»
					«val elem = (tabContainer as ContainerElementDef).value»
					«val tabName = getTabName(elem)»
					«val fragmentName = getName(elem).toFirstUpper + "Fragment"»
					bar.addTab(bar
						.newTab()
						.setText(«strings.addString("tabtitle_" + getName(elem).toLowerCase, tabName)»)
						.setTabListener(
							new ChangeTabListener<«fragmentName»>(getApp(), this, "«tabName»",
								«fragmentName».class, "«getName(elem)»", this)));
				«ENDFOR»
				
				if(getIntent() != null && getIntent().getStringExtra("tabToShow") != null) {
					setSelectedTab(getIntent().getStringExtra("tabToShow"));
				}
				«IF dataContainer.tabbedViewContent.contains(resolveViewGUIElement(dataContainer.main.startView))»
					else {
						setSelectedTab("«getName(resolveViewGUIElement(dataContainer.main.startView))»");
					}
				«ENDIF»
			}
			
			private MD2Application getApp() {
				return (MD2Application) getApplication();
			}
		}
	'''
	
	
	/////////////////////////////////////////
	// Fragment
	/////////////////////////////////////////
	
	
	def generateFragment(JavaClassDef classDef, ContainerElement elem) '''
		«classDef.simpleName = getName(elem).toFirstUpper + "Fragment"»
		package «classDef.fullPackage»;
		
		import android.app.DialogFragment;
		import android.app.Fragment;
		import android.os.Bundle;
		import android.view.LayoutInflater;
		import android.view.View;
		import android.view.View.OnClickListener;
		import android.view.ViewGroup;
		import android.widget.ArrayAdapter;
		import android.widget.Button;
		import android.widget.Spinner;
		import android.widget.TextView;
		import de.wwu.md2.android.lib.MD2Application;
		import de.wwu.md2.android.lib.controller.contentprovider.EntitySelectorHandler;
		import de.wwu.md2.android.lib.controller.events.MD2EventHandler;
		import de.wwu.md2.android.lib.controller.events.MD2FocusLeftEvent;
		import de.wwu.md2.android.lib.controller.events.MD2ItemSelectedEvent;
		import de.wwu.md2.android.lib.controller.events.MD2TouchEvent;
		import de.wwu.md2.android.lib.controller.validators.NotNullValidator;
		import de.wwu.md2.android.lib.view.DatePickerFragment;
		import de.wwu.md2.android.lib.view.DateTimePickerFragment;
		import de.wwu.md2.android.lib.view.MessageBoxFragment;
		import de.wwu.md2.android.lib.view.TimePickerFragment;
		import «classDef.basePackage».R;
		
		@SuppressWarnings("unused")
		public class «classDef.simpleName» extends Fragment {
			
			private View view;
			private boolean isInitialized;
			
			@Override
			public View onCreateView(LayoutInflater inflater, ViewGroup container,
					Bundle savedInstanceState) {
				// If the view is already inflated, no initialization is required
				isInitialized = view != null;
				
				if(!isInitialized) {
					// Check whether app object has to be reinitialized
					getApp().checkForReinitialization("«getName(elem).toFirstUpper»");
					
					view = inflater.inflate(R.layout.«getName(elem).toLowerCase», container, false);
				}
				
				return view;
			}
			
			@Override
			public void onActivityCreated(Bundle savedInstanceState) {
				super.onActivityCreated(savedInstanceState);
				
				if(!isInitialized) {
					// Initialize date and time pickers
					initializeDateTimePickers();
					
					// Initialize event handling
					initializeEvents();
					
					// Initialize tool tips
					initializeToolTips();
					
					// Initialize entity selectors
					initializeEntitySelectors();
					
					isInitialized = true;
				}
			}
			
			@Override
		    public void onResume() {
		        super.onResume();
		        
				getApp().setActiveActivity("«getName(elem).toFirstUpper»", getActivity());
		    }
			
			@Override
			public void onHiddenChanged(boolean hidden) {
				// Additionally to onResume this method has to be used to notify on tab
				// changes, because hiding and then showing a tab does not lead to a
				// call of onResume.
				if (!hidden) {
					getApp().setActiveActivity("«getName(elem).toFirstUpper»", getActivity());
				}
			}
			
			private void initializeDateTimePickers() {
				«generateDateTimePickerInitialization(elem, "getView().")»
			}
			
			private void initializeToolTips() {
				«generateToolTipInitialization(elem, "getView().")»
			}
			
			private void initializeEvents() {
				«generateEventInitialization(elem, "getView().")»
			}
			
			private void initializeEntitySelectors() {
				«generateEntitySelectorsInitialization(elem, classDef.basePackage, "getActivity()", "getView().")»
			}
			
			private MD2Application getApp() {
				return (MD2Application) getActivity().getApplication();
			}
		}
	'''
	
	
	/////////////////////////////////////////
	// Generate date and time picker initialization
	/////////////////////////////////////////
	
	
	def private dispatch CharSequence generateDateTimePickerInitialization(ViewElement elem, String findViewByIdPrefix) '''
		«/* Nothing to do for other kinds of view elements */»'''
	
	def private dispatch CharSequence generateDateTimePickerInitialization(GridLayoutPane elem, String findViewByIdPrefix) '''
		«FOR viewElemType : elem.elements»
			«generateDateTimePickerInitialization(getViewGUIElement(viewElemType), findViewByIdPrefix)»
		«ENDFOR»
	'''
	
	def private dispatch CharSequence generateDateTimePickerInitialization(FlowLayoutPane elem, String findViewByIdPrefix) '''
		«FOR viewElemType : elem.elements»
			«generateDateTimePickerInitialization(getViewGUIElement(viewElemType), findViewByIdPrefix)»
		«ENDFOR»
	'''
	
	def private dispatch CharSequence generateDateTimePickerInitialization(TextInput elem, String findViewByIdPrefix) '''
		«IF elem.type == DATE»
			«findViewByIdPrefix»findViewById(R.id.«getName(elem)»SetButton)
				.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						«findViewByIdPrefix»findViewById(R.id.«getName(elem)»SetButton).requestFocusFromTouch();
						DialogFragment newFragment = new DatePickerFragment(
							(TextView) «findViewByIdPrefix»findViewById(R.id.«getName(elem)»));
						newFragment.show(getFragmentManager(),
							"«getName(elem)»DatePicker");
					}
				});
		«ELSEIF elem.type == TIME»
			«findViewByIdPrefix»findViewById(R.id.«getName(elem)»SetButton)
				.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						«findViewByIdPrefix»findViewById(R.id.«getName(elem)»SetButton).requestFocusFromTouch();
						DialogFragment newFragment = new TimePickerFragment(
							(TextView) «findViewByIdPrefix»findViewById(R.id.«getName(elem)»));
						newFragment.show(getFragmentManager(),
							"«getName(elem)»TimePicker");
					}
				});
		«ELSEIF elem.type == DATE_TIME»
			«findViewByIdPrefix»findViewById(R.id.«getName(elem)»SetButton)
				.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						«findViewByIdPrefix»findViewById(R.id.«getName(elem)»SetButton).requestFocusFromTouch();
						DialogFragment newFragment = new DateTimePickerFragment(
							(TextView) «findViewByIdPrefix»findViewById(R.id.«getName(elem)»));
						newFragment.show(getFragmentManager(),
							"«getName(elem)»DateTimePicker");
					}
				});
		«ENDIF»
	'''
	
	
	/////////////////////////////////////////
	// Generate tool tip initialization
	/////////////////////////////////////////
	
	
	def private dispatch CharSequence generateToolTipInitialization(ViewElement elem, String findViewByIdPrefix) '''
		«/* Nothing to do for other kinds of view elements */»'''
	
	def private dispatch CharSequence generateToolTipInitialization(GridLayoutPane elem, String findViewByIdPrefix) '''
		«FOR viewElemType : elem.elements»
			«generateToolTipInitialization(getViewGUIElement(viewElemType), findViewByIdPrefix)»
		«ENDFOR»
	'''
	
	def private dispatch CharSequence generateToolTipInitialization(FlowLayoutPane elem, String findViewByIdPrefix) '''
		«FOR viewElemType : elem.elements»
			«generateToolTipInitialization(getViewGUIElement(viewElemType), findViewByIdPrefix)»
		«ENDFOR»
	'''
	
	def private dispatch CharSequence generateToolTipInitialization(TextInput elem, String findViewByIdPrefix) '''
		«IF elem.tooltipText != null»
			«findViewByIdPrefix»findViewById(R.id.«getName(elem)»ToolTip)
				.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						DialogFragment newFragment = new MessageBoxFragment(
							"«elem.tooltipText»");
						newFragment.show(getFragmentManager(),
							"«getName(elem)»ToolTip");
					}
				});
		«ENDIF»
	'''
	
	def private dispatch CharSequence generateToolTipInitialization(OptionInput elem, String findViewByIdPrefix) '''
		«IF elem.tooltipText != null»
			«findViewByIdPrefix»findViewById(R.id.«getName(elem)»ToolTip)
				.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						DialogFragment newFragment = new MessageBoxFragment(
							"«elem.tooltipText»");
						newFragment.show(getFragmentManager(),
							"«getName(elem)»ToolTip");
					}
				});
		«ENDIF»
	'''
	
	def private dispatch CharSequence generateToolTipInitialization(CheckBox elem, String findViewByIdPrefix) '''
		«IF elem.tooltipText != null»
			«findViewByIdPrefix»findViewById(R.id.«getName(elem)»ToolTip)
				.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						DialogFragment newFragment = new MessageBoxFragment(
							"«elem.tooltipText»");
						newFragment.show(getFragmentManager(),
							"«getName(elem)»ToolTip");
					}
				});
		«ENDIF»
	'''
	
	def private dispatch CharSequence generateToolTipInitialization(Tooltip elem, String findViewByIdPrefix) '''
		«findViewByIdPrefix»findViewById(R.id.«getName(elem)»)
			.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					DialogFragment newFragment = new MessageBoxFragment(
						"«elem.text»");
					newFragment.show(getFragmentManager(),
						"«getName(elem)»ToolTip");
				}
			});
	'''
	
	
	/////////////////////////////////////////
	// Generate event initialization
	/////////////////////////////////////////
	
	
	def private dispatch CharSequence generateEventInitialization(ViewElement elem, String findViewByIdPrefix) '''
		«/* Nothing to do for other kinds of view elements */»'''
	
	def private dispatch CharSequence generateEventInitialization(GridLayoutPane elem, String findViewByIdPrefix) '''
		«FOR viewElemType : elem.elements»
			«generateEventInitialization(getViewGUIElement(viewElemType), findViewByIdPrefix)»
		«ENDFOR»
	'''
	
	def private dispatch CharSequence generateEventInitialization(FlowLayoutPane elem, String findViewByIdPrefix) '''
		«FOR viewElemType : elem.elements»
			«generateEventInitialization(getViewGUIElement(viewElemType), findViewByIdPrefix)»
		«ENDFOR»
	'''
	
	def private dispatch CharSequence generateEventInitialization(TextInput elem, String findViewByIdPrefix) '''
		«findViewByIdPrefix»findViewById(R.id.«getName(elem)»).setOnFocusChangeListener(new MD2FocusLeftEvent(getApp().getEventBus(), "«getName(elem)»_FocusLeft"));
		«findViewByIdPrefix»findViewById(R.id.«getName(elem)»).setOnClickListener(new MD2TouchEvent(getApp().getEventBus(), "«getName(elem)»_Touched"));
		«IF elem.type == DATE || elem.type == TIME || elem.type == DATE_TIME»
			«findViewByIdPrefix»findViewById(R.id.«getName(elem)»SetButton).setOnFocusChangeListener(new MD2FocusLeftEvent(getApp().getEventBus(), "«getName(elem)»_FocusLeft"));
			«findViewByIdPrefix»findViewById(R.id.«getName(elem)»).setOnClickListener(new MD2TouchEvent(getApp().getEventBus(), "«getName(elem)»_Touched"));
		«ENDIF»
	'''
	
	def private dispatch CharSequence generateEventInitialization(OptionInput elem, String findViewByIdPrefix) '''
		((Spinner)«findViewByIdPrefix»findViewById(R.id.«getName(elem)»)).setOnItemSelectedListener(new MD2ItemSelectedEvent(getApp().getEventBus(), "«getName(elem)»_FocusLeft"));
	'''
	
	def private dispatch CharSequence generateEventInitialization(CheckBox elem, String findViewByIdPrefix) '''
		«findViewByIdPrefix»findViewById(R.id.«getName(elem)»).setOnFocusChangeListener(new MD2FocusLeftEvent(getApp().getEventBus(), "«getName(elem)»_FocusLeft"));
		«findViewByIdPrefix»findViewById(R.id.«getName(elem)»).setOnClickListener(new MD2TouchEvent(getApp().getEventBus(), "«getName(elem)»_Touched"));
	'''
	
	def private dispatch CharSequence generateEventInitialization(Button elem, String findViewByIdPrefix) '''
		«findViewByIdPrefix»findViewById(R.id.«getName(elem)»).setOnClickListener(new MD2TouchEvent(getApp().getEventBus(), "«getName(elem)»_Touched"));
	'''
	
	
	/////////////////////////////////////////
	// Generate entity selectors initialization
	/////////////////////////////////////////
	
	
	def private dispatch CharSequence generateEntitySelectorsInitialization(ViewElement elem, String basePackage, String getContext, String findViewByIdPrefix) '''
		«/* Nothing to do for other kinds of view elements */»'''
	
	def private dispatch CharSequence generateEntitySelectorsInitialization(GridLayoutPane elem, String basePackage, String getContext, String findViewByIdPrefix) '''
		«FOR viewElemType : elem.elements»
			«generateEntitySelectorsInitialization(getViewGUIElement(viewElemType), basePackage, getContext, findViewByIdPrefix)»
		«ENDFOR»
	'''
	
	def private dispatch CharSequence generateEntitySelectorsInitialization(FlowLayoutPane elem, String basePackage, String getContext, String findViewByIdPrefix) '''
		«FOR viewElemType : elem.elements»
			«generateEntitySelectorsInitialization(getViewGUIElement(viewElemType), basePackage, getContext, findViewByIdPrefix)»
		«ENDFOR»
	'''
	
	def private dispatch CharSequence generateEntitySelectorsInitialization(EntitySelector elem, String basePackage, String getContext, String findViewByIdPrefix) '''
		«val contentProvider = elem.textProposition.contentProviderRef»
		«val entity = (contentProvider.type as ReferencedModelType).entity»
		«val entityFQN = basePackage + ".models." + entity.name»
		new EntitySelectorHandler<«entityFQN»>(«getContext», getApp().getEventBus(), ((Spinner)«findViewByIdPrefix»findViewById(R.id.«getName(elem)»)), getApp().findContentProviderByType(«basePackage».contentprovider.«contentProvider.name.toFirstUpper».class)) {

			@Override
			protected String resolveName(«entityFQN» entity) {
				«val attributePath =  getPathTailAsList(elem.textProposition.tail)»
				«val getPath = attributePath.join(".", ['''get«it.name.toFirstUpper»()'''])»
				return entity.«getPath».toString();
			}
		};
	'''
	
	/////////////////////////////////////////
	// Helper methods
	/////////////////////////////////////////
	
	
	def private getViewGUIElement(ViewElementType viewElemType) {
		switch viewElemType {
			ViewElementRef: viewElemType.value
			ViewElementDef: viewElemType.value
		}
	}
}
