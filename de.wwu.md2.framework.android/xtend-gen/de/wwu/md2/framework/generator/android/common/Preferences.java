package de.wwu.md2.framework.generator.android.common;

import org.eclipse.xtend2.lib.StringConcatenation;

@SuppressWarnings("all")
public class Preferences {
  public static CharSequence preferences() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("eclipse.preferences.version=1");
    _builder.newLine();
    _builder.append("encoding/<project>=UTF-8");
    _builder.newLine();
    return _builder;
  }
}
