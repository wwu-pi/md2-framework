package de.wwu.md2.framework.generator.android.templates;

import java.util.HashMap;

@SuppressWarnings("all")
public class StringsXmlTemplate /* implements AbstractTemplate  */{
  private HashMap<String,String> stringsMap /* Skipped initializer because of errors */;
  
  protected CharSequence executionOrder() {
    CharSequence _template = this.template();
    return _template;
  }
  
  protected CharSequence template() {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method getContentFor is undefined for the type StringsXmlTemplate");
  }
  
  /**
   * Adds a new entry to the strings.xml
   * @param name The desired key for the entry
   * @param value The entry value
   * @return The resource id (i.e. "R.string.#{name}")
   */
  public String addString(final String name, final String value) {
    throw new Error("Unresolved compilation problems:"
      + "\n!= cannot be resolved."
      + "\n! cannot be resolved."
      + "\n== cannot be resolved."
      + "\nThe method contentFor is undefined for the type StringsXmlTemplate"
      + "\n+ cannot be resolved."
      + "\n&& cannot be resolved"
      + "\n<< cannot be resolved");
  }
  
  /**
   * Adds a new entry just like addString, but returns the resource id in XML syntax
   * @return Resource id suitable for accessing the string from XML (<code>@string/$name</code>)
   * @see addString
   */
  public Object addForXml(final String name, final String value) {
    throw new Error("Unresolved compilation problems:"
      + "\n+ cannot be resolved.");
  }
}
