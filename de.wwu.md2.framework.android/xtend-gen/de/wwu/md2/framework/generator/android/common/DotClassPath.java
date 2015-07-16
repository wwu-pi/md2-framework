package de.wwu.md2.framework.generator.android.common;

import org.eclipse.xtend2.lib.StringConcatenation;

@SuppressWarnings("all")
public class DotClassPath {
  public static CharSequence dotClassPath() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    _builder.newLine();
    _builder.append("<classpath>");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("<classpathentry kind=\"src\" path=\"src\"/>");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("<classpathentry kind=\"src\" path=\"gen\"/>");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("<classpathentry kind=\"con\" path=\"com.android.ide.eclipse.adt.ANDROID_FRAMEWORK\"/>");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("<classpathentry kind=\"con\" path=\"com.android.ide.eclipse.adt.LIBRARIES\"/>");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("<classpathentry exported=\"true\" kind=\"lib\" path=\"lib/guava-10.0.1.jar\"/>");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("<classpathentry exported=\"true\" kind=\"lib\" path=\"lib/jackson-all-1.9.9.jar\"/>");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("<classpathentry exported=\"true\" kind=\"lib\" path=\"lib/md2-android-lib.jar\"/>");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("<classpathentry kind=\"output\" path=\"bin/classes\"/>");
    _builder.newLine();
    _builder.append("</classpath>");
    _builder.newLine();
    return _builder;
  }
}
