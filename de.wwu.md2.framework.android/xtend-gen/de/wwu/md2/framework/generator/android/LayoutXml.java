package de.wwu.md2.framework.generator.android;

import de.wwu.md2.framework.generator.android.templates.StringsXmlTemplate;
import de.wwu.md2.framework.generator.util.MD2GeneratorUtil;
import java.util.Arrays;
import java.util.Collection;
import org.eclipse.xtend2.lib.StringConcatenation;

@SuppressWarnings("all")
public class LayoutXml {
  private boolean isRootGenerated;
  
  private StringsXmlTemplate strings;
  
  /* @Property
   */private /* Collection<ContainerElement> */Object newFragmentsToGenerate;
  
  public LayoutXml(final StringsXmlTemplate stringsTemplate) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field newHashSet is undefined for the type LayoutXml");
  }
  
  public Object text(final /* EObject */Object obj, final String text) {
    throw new Error("Unresolved compilation problems:"
      + "\n+ cannot be resolved.");
  }
  
  public CharSequence generateLayoutXml(final /* ContainerElement */Object baseViewElem) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
    _builder.newLine();
    CharSequence _generateElem = this.generateElem(baseViewElem);
    _builder.append(_generateElem, "");
    _builder.newLineIfNotEmpty();
    return _builder;
  }
  
  private CharSequence _generateElem(final /* TextInput */Object elem) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field DATE is undefined for the type LayoutXml"
      + "\nThe method or field TIME is undefined for the type LayoutXml"
      + "\nThe method or field DATE_TIME is undefined for the type LayoutXml"
      + "\n+ cannot be resolved."
      + "\nThe method or field DATE is undefined for the type LayoutXml"
      + "\nThe method or field TIME is undefined for the type LayoutXml"
      + "\nThe method or field DATE_TIME is undefined for the type LayoutXml"
      + "\nlabelText cannot be resolved"
      + "\n!= cannot be resolved"
      + "\n|| cannot be resolved"
      + "\ntooltipText cannot be resolved"
      + "\n!= cannot be resolved"
      + "\n|| cannot be resolved"
      + "\ntype cannot be resolved"
      + "\n== cannot be resolved"
      + "\n|| cannot be resolved"
      + "\ntype cannot be resolved"
      + "\n== cannot be resolved"
      + "\n|| cannot be resolved"
      + "\ntype cannot be resolved"
      + "\n== cannot be resolved"
      + "\nlabelText cannot be resolved"
      + "\n!= cannot be resolved"
      + "\nlabelText cannot be resolved"
      + "\ntooltipText cannot be resolved"
      + "\n!= cannot be resolved"
      + "\nlabelText cannot be resolved"
      + "\n!= cannot be resolved"
      + "\n|| cannot be resolved"
      + "\ntooltipText cannot be resolved"
      + "\n!= cannot be resolved"
      + "\n|| cannot be resolved"
      + "\ntype cannot be resolved"
      + "\n== cannot be resolved"
      + "\n|| cannot be resolved"
      + "\ntype cannot be resolved"
      + "\n== cannot be resolved"
      + "\n|| cannot be resolved"
      + "\ntype cannot be resolved"
      + "\n== cannot be resolved");
  }
  
  private CharSequence generateTextInput(final /* TextInput */Object elem) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field DATE is undefined for the type LayoutXml"
      + "\nThe method or field TIME is undefined for the type LayoutXml"
      + "\nThe method or field DATE_TIME is undefined for the type LayoutXml"
      + "\ntype cannot be resolved"
      + "\n== cannot be resolved"
      + "\n|| cannot be resolved"
      + "\ntype cannot be resolved"
      + "\n== cannot be resolved"
      + "\n|| cannot be resolved"
      + "\ntype cannot be resolved"
      + "\n== cannot be resolved");
  }
  
  private CharSequence _generateElem(final /* OptionInput */Object elem) {
    throw new Error("Unresolved compilation problems:"
      + "\n+ cannot be resolved."
      + "\nlabelText cannot be resolved"
      + "\n!= cannot be resolved"
      + "\n|| cannot be resolved"
      + "\ntooltipText cannot be resolved"
      + "\n!= cannot be resolved"
      + "\nlabelText cannot be resolved"
      + "\n!= cannot be resolved"
      + "\nlabelText cannot be resolved"
      + "\ntooltipText cannot be resolved"
      + "\n!= cannot be resolved"
      + "\nlabelText cannot be resolved"
      + "\n!= cannot be resolved"
      + "\n|| cannot be resolved"
      + "\ntooltipText cannot be resolved"
      + "\n!= cannot be resolved");
  }
  
  private CharSequence generateOptionInput(final /* OptionInput */Object elem) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("<Spinner");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("android:id=\"@+id/");
    String _name = MD2GeneratorUtil.getName(elem);
    _builder.append(_name, "\t");
    _builder.append("\"");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.append("style=\"@style/ContentDefault\" />");
    _builder.newLine();
    return _builder;
  }
  
  private CharSequence _generateElem(final /* Label */Object elem) {
    throw new Error("Unresolved compilation problems:"
      + "\nStyleDefinition cannot be resolved to a type."
      + "\nStyleDefinition cannot be resolved to a type."
      + "\nstyle cannot be resolved"
      + "\n!= cannot be resolved"
      + "\nstyle cannot be resolved"
      + "\ndefinition cannot be resolved"
      + "\ntext cannot be resolved"
      + "\ntext cannot be resolved");
  }
  
  private CharSequence generateLabel(final String text) {
    return this.generateLabel(null, text, null);
  }
  
  private CharSequence generateLabel(final String name, final String text, final CharSequence style) {
    throw new Error("Unresolved compilation problems:"
      + "\n!= cannot be resolved."
      + "\n!= cannot be resolved."
      + "\n!= cannot be resolved."
      + "\n+ cannot be resolved.");
  }
  
  private CharSequence _generateElem(final /* Image */Object elem) {
    throw new Error("Unresolved compilation problems:"
      + "\nwidth cannot be resolved"
      + "\n== cannot be resolved"
      + "\nwidth cannot be resolved"
      + "\nheight cannot be resolved"
      + "\n== cannot be resolved"
      + "\nheight cannot be resolved"
      + "\nsrc cannot be resolved"
      + "\nreplaceAll cannot be resolved"
      + "\nreplaceAll cannot be resolved");
  }
  
  /**
   * Returns an empty element as spacer
   */
  private CharSequence _generateElem(final /* Spacer */Object elem) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("<TextView />");
    _builder.newLine();
    return _builder;
  }
  
  private CharSequence _generateElem(final /* Button */Object elem) {
    throw new Error("Unresolved compilation problems:"
      + "\nStyleDefinition cannot be resolved to a type."
      + "\nStyleDefinition cannot be resolved to a type."
      + "\nstyle cannot be resolved"
      + "\n!= cannot be resolved"
      + "\nstyle cannot be resolved"
      + "\ndefinition cannot be resolved"
      + "\ntext cannot be resolved"
      + "\ntext cannot be resolved");
  }
  
  private CharSequence _generateElem(final /* CheckBox */Object elem) {
    throw new Error("Unresolved compilation problems:"
      + "\n+ cannot be resolved."
      + "\ntooltipText cannot be resolved"
      + "\n!= cannot be resolved"
      + "\nlabelText cannot be resolved"
      + "\n!= cannot be resolved"
      + "\ntext cannot be resolved"
      + "\nlabelText cannot be resolved"
      + "\nchecked cannot be resolved"
      + "\ntooltipText cannot be resolved"
      + "\n!= cannot be resolved"
      + "\ntooltipText cannot be resolved"
      + "\n!= cannot be resolved");
  }
  
  private CharSequence _generateElem(final /* Tooltip */Object elem) {
    String _name = MD2GeneratorUtil.getName(elem);
    return this.generateToolTip(_name);
  }
  
  public CharSequence generateToolTip(final String name) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("<ImageButton ");
    _builder.newLine();
    _builder.append("    ");
    _builder.append("android:id=\"@+id/");
    _builder.append(name, "    ");
    _builder.append("\"");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.append("style=\"@style/ContentDefault.ToolTipDefault\"");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("android:contentDescription=\"");
    StringConcatenation _builder_1 = new StringConcatenation();
    _builder_1.append("tooltipImage_contentDesc");
    Object _addForXml = this.strings.addForXml(_builder_1.toString(), "Tooltip");
    _builder.append(_addForXml, "\t");
    _builder.append("\" />");
    _builder.newLineIfNotEmpty();
    return _builder;
  }
  
  private CharSequence _generateElem(final /* EntitySelector */Object elem) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("<Spinner");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("android:id=\"@+id/");
    String _name = MD2GeneratorUtil.getName(elem);
    _builder.append(_name, "\t");
    _builder.append("\"");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.append("style=\"@style/ContentDefault\" />");
    _builder.newLine();
    return _builder;
  }
  
  private String getInputType(final /* TextInput */Object elem) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field DATE is undefined for the type LayoutXml"
      + "\nThe method or field TIME is undefined for the type LayoutXml"
      + "\nThe method or field DATE_TIME is undefined for the type LayoutXml"
      + "\nThe method or field DEFAULT is undefined for the type LayoutXml"
      + "\ntype cannot be resolved");
  }
  
  private CharSequence generateStyle(final /* StyleBody */Object style) {
    throw new Error("Unresolved compilation problems:"
      + "\nHexColorDef cannot be resolved to a type."
      + "\nfontSize cannot be resolved"
      + "\n!= cannot be resolved"
      + "\nfontSize cannot be resolved"
      + "\ncolor cannot be resolved"
      + "\n!= cannot be resolved"
      + "\ncolor cannot be resolved"
      + "\ncolor cannot be resolved"
      + "\nbold cannot be resolved"
      + "\n&& cannot be resolved"
      + "\nitalic cannot be resolved"
      + "\nbold cannot be resolved"
      + "\nitalic cannot be resolved");
  }
  
  private CharSequence _generateElem(final /* GridLayoutPane */Object elem) {
    throw new Error("Unresolved compilation problems:"
      + "\n! cannot be resolved."
      + "\n+ cannot be resolved."
      + "\nelements cannot be resolved"
      + "\nslice cannot be resolved");
  }
  
  private CharSequence _generateElem(final /* FlowLayoutPane */Object elem) {
    throw new Error("Unresolved compilation problems:"
      + "\n! cannot be resolved."
      + "\nelements cannot be resolved");
  }
  
  private CharSequence _generateElem(final /* AlternativesPane */Object elem) {
    StringConcatenation _builder = new StringConcatenation();
    return _builder;
  }
  
  private CharSequence _generateElem(final /* TabbedAlternativesPane */Object elem) {
    StringConcatenation _builder = new StringConcatenation();
    return _builder;
  }
  
  private Object getViewGUIElement(final /* ViewElementType */Object viewElemType) {
    throw new Error("Unresolved compilation problems:"
      + "\nViewElementRef cannot be resolved to a type."
      + "\nViewElementDef cannot be resolved to a type."
      + "\nUnreachable code: The case can never match. It is already handled by a previous condition."
      + "\nvalue cannot be resolved"
      + "\nvalue cannot be resolved");
  }
  
  private int getColumnsCount(final /* GridLayoutPane */Object grdPane) {
    throw new Error("Unresolved compilation problems:"
      + "\nGridLayoutPaneRowsParam cannot be resolved to a type."
      + "\nGridLayoutPaneColumnsParam cannot be resolved to a type."
      + "\n== cannot be resolved."
      + "\nUnreachable code: The case can never match. It is already handled by a previous condition."
      + "\nparams cannot be resolved"
      + "\nvalue cannot be resolved"
      + "\nvalue cannot be resolved"
      + "\nelements cannot be resolved"
      + "\nsize cannot be resolved"
      + "\ndoubleValue cannot be resolved"
      + "\n/ cannot be resolved");
  }
  
  private String getFlowDirection(final /* FlowLayoutPane */Object flowPane) {
    throw new Error("Unresolved compilation problems:"
      + "\nFlowLayoutPaneFlowDirectionParam cannot be resolved to a type."
      + "\nFlowDirection cannot be resolved to a type."
      + "\nFlowDirection cannot be resolved to a type."
      + "\nparams cannot be resolved"
      + "\nfilter cannot be resolved"
      + "\nlast cannot be resolved"
      + "\nflowDirection cannot be resolved"
      + "\nHORIZONTAL cannot be resolved"
      + "\nVERTICAL cannot be resolved");
  }
  
  private boolean checkIsRootGenerated() {
    throw new Error("Unresolved compilation problems:"
      + "\n! cannot be resolved.");
  }
  
  private CharSequence generateElem(final TextInput elem) {
    if (elem != null) {
      return _generateElem(elem); else {
        throw new IllegalArgumentException("Unhandled parameter types: " +
          Arrays.<Object>asList(elem).toString());
      }
    }
  }
  