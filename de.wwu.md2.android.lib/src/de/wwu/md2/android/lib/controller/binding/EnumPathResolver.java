package de.wwu.md2.android.lib.controller.binding;

import de.wwu.md2.android.lib.model.Entity;
import de.wwu.md2.android.lib.model.MD2Enum;

public abstract class EnumPathResolver<E extends Entity> implements PathResolver<E, Integer> {

	public abstract MD2Enum getEnum(E entity);

	@Override
	public Integer retrieveValue(E entity) {
		return getEnum(entity).getSelectedIdx();
	}

	@Override
	public void adaptValue(E entity, Integer value) {
		getEnum(entity).setSelectedIdx(value);
	}

}