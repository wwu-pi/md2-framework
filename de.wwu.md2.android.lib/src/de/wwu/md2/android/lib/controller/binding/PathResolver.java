package de.wwu.md2.android.lib.controller.binding;

import de.wwu.md2.android.lib.model.Entity;

/**
 * Strategy interface to implement the Path of the Mapping.
 * 
 */
public interface PathResolver<E extends Entity, V> {

	/**
	 * Calls the path on the the entity.
	 * 
	 * @param entity
	 *            The model instance that is read on.
	 * @return Current value on this path for the entity.
	 */
	V retrieveValue(E entity);
	
	void adaptValue(E entity, V value);
}
