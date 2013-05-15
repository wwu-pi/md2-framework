package de.wwu.md2.framework.generator.android.common.templates;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * Parent class for concrete templates.
 * 
 * The idea here is to have a two-phase-templating consisting of regions. In the
 * first phase, all partials fill the template's regions. Partials are
 * sub-templates that may add content to regions. Regions are areas of the
 * template that are filled by partials. In the second phase, the main template
 * is called. It uses getContentsFor as a placeholder for region content.
 * 
 */
public abstract class AbstractTemplate {
	
	private final Map<String, List<ContentAdder>> partials = new HashMap<String, List<ContentAdder>>();
	
	/**
	 * Defines an execution order for partials.
	 * 
	 * This is basically a callback for actions to be done before template() is called.
	 */
	protected abstract void executionOrder();
	
	/**
	 * Returns the main content of this template.
	 * 
	 * Should use getContentsFor as a placeholder for region content.
	 * 
	 * @return The main template content
	 */
	protected abstract CharSequence template();
	
	/**
	 * Callback for partials to add content to regions. 
	 * 
	 * May only be called from within partials.
	 * Style is:
	 * contenFor("region") << '''The content'''
	 * 
	 * @param key The region key.
	 * @return A ContentAdder for adding the content.
	 */
	protected ContentAdder contentFor(String key) {
		List<ContentAdder> partialsForKey = partials.get(key);
		if (partialsForKey == null)
			partialsForKey = new LinkedList<ContentAdder>();
		ContentAdder adder = new ContentAdder();
		partialsForKey.add(adder);
		partials.put(key, partialsForKey);
		return adder;
	}
	
	/**
	 * 
	 * @param key The region.
	 * @return Contents that all partials returned for that region.
	 */
	protected CharSequence getContentFor(String key) {
		StringBuilder sb = new StringBuilder();
		List<ContentAdder> contentAdders = partials.get(key);
		if (contentAdders != null) {
			for (ContentAdder adder : contentAdders) {
				sb.append(adder.getContent());
			}
		}
		
		return sb.toString();
		
	}
	
	public static CharSequence fuerSoeren(Class<? extends AbstractTemplate> templateClass) throws InstantiationException, IllegalAccessException {
		AbstractTemplate template = templateClass.newInstance();
		return template.render();
	}
	
	/**
	 * Renders the template
	 * @return
	 */
	public CharSequence render() {
		executionOrder();
		return template();
	}
	
}
