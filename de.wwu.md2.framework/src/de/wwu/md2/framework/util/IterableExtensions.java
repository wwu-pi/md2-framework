package de.wwu.md2.framework.util;

import java.util.Collections;
import java.util.Iterator;

import org.eclipse.xtext.xbase.lib.Functions;

import com.google.common.collect.AbstractIterator;

public class IterableExtensions {

	public static <T> String joinWithIdx(
			Iterable<T> iterable,
			CharSequence before,
			CharSequence separator,
			CharSequence after,
			Functions.Function2<? super T, Integer, ? extends CharSequence> function) {
		if (function == null)
			throw new NullPointerException("function");
		StringBuilder result = new StringBuilder();
		Iterator<T> iterator = iterable.iterator();
		boolean notEmpty = iterator.hasNext();
		if (notEmpty && before != null)
			result.append(before);
		int idx = 0;
		while (iterator.hasNext()) {
			T next = iterator.next();
			CharSequence elementToString = function.apply(next, new Integer(
					idx++));
			result.append(elementToString);
			if (iterator.hasNext() && separator != null)
				result.append(separator);
		}
		if (notEmpty && after != null)
			result.append(after);
		return result.toString();
	}

	/**
	 * Returns a view on this iterable that provides its entries in slices with
	 * <code>count</code> elements.
	 * @param iterable
	 *            the iterable. May not be <code>null</code>.
	 * @param count
	 *            the number of elements that should be returned for each slice.
	 * @return an iterator over slices with <code>count</code> elements. Never
	 *         <code>null</code>.
	 * @throws IllegalArgumentException
	 *             if <code>count</code> is negative.
	 * 
	 */
	public static <T> Iterable<Iterable<T>> slice(final Iterable<T> iterable,
			final int count) {
		if (iterable == null)
			throw new NullPointerException("iterable");
		if (count < 0)
			throw new IllegalArgumentException(
					"Cannot take a negative number of elements. Argument 'count' was: "
							+ count);
		if (count == 0)
			return Collections.emptyList();
		return new Iterable<Iterable<T>>() {
			public Iterator<Iterable<T>> iterator() {
				return new AbstractIterator<Iterable<T>>() {
					private final Iterator<T> delegate = iterable.iterator();

					protected Iterable<T> computeNext() {
						if (!delegate.hasNext())
							return endOfData();
						return new Iterable<T>() {
							public Iterator<T> iterator() {
								return new AbstractIterator<T>() {
									private int remaining = count;

									protected T computeNext() {
										if (remaining <= 0)
											return endOfData();
										if (!delegate.hasNext())
											return endOfData();
										remaining--;
										return delegate.next();
									}
								};
							}

						};
					}
				};
			}
		};
	}
}