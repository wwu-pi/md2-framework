package de.wwu.md2.android.lib.controller.contentprovider;

import java.util.LinkedList;
import java.util.List;

import android.content.Context;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ArrayAdapter;
import android.widget.Spinner;
import de.wwu.md2.android.lib.controller.events.MD2EventBus;
import de.wwu.md2.android.lib.controller.events.MD2EventHandler;
import de.wwu.md2.android.lib.model.Entity;

public abstract class EntitySelectorHandler<E extends Entity> implements OnItemSelectedListener, MD2EventHandler {
	
	private Spinner spinner;
	private RemoteManyContentProvider<E> contentProvider;
	private Context context;
	private boolean avoidReinitialization;
	
	public EntitySelectorHandler(Context context, MD2EventBus eventBus, Spinner spinner,
			RemoteManyContentProvider<E> contentProvider) {
		this.spinner = spinner;
		this.contentProvider = contentProvider;
		this.context = context;
		
		// Initialize spinner values
		setSpinnerValues();
		
		// Subscribe on event bus
		eventBus.subscribe(contentProvider.getClass().getSimpleName() + "_Reloaded", contentProvider.getClass()
				.getSimpleName() + "_Reloaded_" + spinner.getId(), this);
	}
	
	private void setSpinnerValues() {
		List<CharSequence> names = new LinkedList<CharSequence>();
		List<E> entities = contentProvider.getEntityList();
		for (E entity : entities) {
			names.add(resolveName(entity));
		}
		
		final ArrayAdapter<CharSequence> adapter = new ArrayAdapter<CharSequence>(context,
				android.R.layout.simple_spinner_item, names);
		
		// Specify the layout to use when the list of choices appears
		adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
		// Apply the adapter to the spinner
		spinner.setAdapter(adapter);
		spinner.setOnItemSelectedListener(this);
	}
	
	protected abstract String resolveName(E entity);
	
	@Override
	public void eventOccured() {
		if (!avoidReinitialization) {
			setSpinnerValues();
		}
	}
	
	@Override
	public void onItemSelected(AdapterView<?> parent, View view, int pos, long id) {
		avoidReinitialization = true;
		contentProvider.selectEntity(pos);
		avoidReinitialization = false;
	}
	
	@Override
	public void onNothingSelected(AdapterView<?> parent) {
		// Nothing to do
	}
}
