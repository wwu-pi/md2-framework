package de.wwu.md2.framework.generator.android.common;

@SuppressWarnings("all")
public class Preferences {
  public static CharSequence preferences() {
    org.eclipse.xtend2.lib.StringConcatenation _builder = new org.eclipse.xtend2.lib.StringConcatenation();
    _builder.append("eclipse.preferences.version=1");
    _builder.newLine();
    _builder.append("encoding/<project>=UTF-8");
    _builder.newLine();
    return _builder;
  }
}
