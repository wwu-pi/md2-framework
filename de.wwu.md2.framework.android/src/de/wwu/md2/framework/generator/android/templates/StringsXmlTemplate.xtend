package de.wwu.md2.framework.generator.android.templates

import de.wwu.md2.framework.generator.android.common.templates.AbstractTemplate
import java.util.HashMap

class StringsXmlTemplate extends AbstractTemplate {
	HashMap<String, String> stringsMap = newHashMap
	
	override protected executionOrder() {
		template()
	}
	
	override protected template() '''
		<?xml version="1.0" encoding="utf-8"?>
		<resources>
		
			«getContentFor("strings")»
		
		</resources>
	'''
	
	/**
	 * Adds a new entry to the strings.xml
	 * @param name The desired key for the entry
	 * @param value The entry value
	 * @return The resource id (i.e. "R.string.#{name}")
	 */
	def String addString(String name, String value) { 
		val oldValue = stringsMap.put(name, value)
		if(oldValue != null && !oldValue.equals(value)) 
			System::out.println('''strings.xml: key '«name»'  already defined with a different value''')
		else if (oldValue == null)
			contentFor("strings") << '''
				<string name="«name»">«value»</string>
			'''
		
		return "R.string."+name
	}
	
	/**
	 * Adds a new entry just like addString, but returns the resource id in XML syntax
	 * @return Resource id suitable for accessing the string from XML (<code>@string/$name</code>)
	 * @see addString
	 */
	def addForXml(String name, String value) { 
		addString(name, value)
		return "@string/" + name
	}

}