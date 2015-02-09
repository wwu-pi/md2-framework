package de.wwu.md2.framework.generator.android.common;

import java.util.List;

@SuppressWarnings("all")
public class Manifest {
  /**
   * Creates the manifest for the app
   * @param activities List of all root views that have been created, the first entry has to be the entry point to the app
   */
  public static CharSequence manifest(final String packageName, final int minAppVersion, final /* DataContainer */Object dataContainer, final /* List<ContainerElement> */Object activities) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method createAppName is undefined for the type Manifest"
      + "\nThe method createAppClassName is undefined for the type Manifest"
      + "\nThe method head is undefined for the type Manifest"
      + "\ncontentProviders cannot be resolved"
      + "\nfilter cannot be resolved"
      + "\nlocal cannot be resolved"
      + "\n! cannot be resolved"
      + "\nempty cannot be resolved"
      + "\n! cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\n+ cannot be resolved"
      + "\n== cannot be resolved");
  }
  
  public static CharSequence activity(final String className, final boolean isMain) {
    org.eclipse.xtend2.lib.StringConcatenation _builder = new org.eclipse.xtend2.lib.StringConcatenation();
    _builder.newLine();
    _builder.append("<activity name=\"");
    _builder.append(className, "");
    _builder.append("\" android:name=\".controller.");
    _builder.append(className, "");
    _builder.append("\" android:label=\"@string/app_name\">");
    _builder.newLineIfNotEmpty();
    {
      if (isMain) {
        _builder.append("\t");
        _builder.append("<intent-filter>");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("\t");
        _builder.append("<action android:name=\"android.intent.action.MAIN\" />");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("\t");
        _builder.append("<category android:name=\"android.intent.category.LAUNCHER\" />");
        _builder.newLine();
        _builder.append("\t");
        _builder.append("</intent-filter> ");
        _builder.newLine();
      }
    }
    _builder.append("</activity>");
    _builder.newLine();
    return _builder;
  }
}
