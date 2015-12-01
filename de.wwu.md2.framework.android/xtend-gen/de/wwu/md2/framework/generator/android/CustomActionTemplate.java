package de.wwu.md2.framework.generator.android;

import java.util.Arrays;
import java.util.List;
import java.util.Set;

@SuppressWarnings("all")
public class CustomActionTemplate {
  private String basePackage;
  
  private /* DataContainer */Object dataContainer;
  
  private /* CustomAction */Object action;
  
  private /* Set<ContainerElement> */Object topLevelViewContainers;
  
  private /* Set<ContainerElement> */Object activities;
  
  private /* Set<ContainerElement> */Object fragments;
  
  public CustomActionTemplate(final String basePackage, final /* CustomAction */Object action, final /* DataContainer */Object dataContainer, final /* Set<ContainerElement> */Object topLevelViewContainers, final /* Set<ContainerElement> */Object activities, final /* Set<ContainerElement> */Object fragments) {
    this.basePackage = basePackage;
    this.action = action;
    this.dataContainer = dataContainer;
    this.topLevelViewContainers = topLevelViewContainers;
    this.activities = activities;
    this.fragments = fragments;
  }
  
  public CharSequence generateCustomAction() {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\ncontentProviders cannot be resolved"
      + "\nempty cannot be resolved"
      + "\n! cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\ncodeFragments cannot be resolved"
      + "\nmap cannot be resolved"
      + "\nfilter cannot be resolved"
      + "\n!= cannot be resolved"
      + "\n&& cannot be resolved"
      + "\nlength cannot be resolved"
      + "\n> cannot be resolved"
      + "\njoin cannot be resolved");
  }
  
  private CharSequence _generateCodeFragment(final /* MappingTask */Object task) {
    throw new Error("Unresolved compilation problems:"
      + "\nTextInput cannot be resolved to a type."
      + "\nOptionInput cannot be resolved to a type."
      + "\nCheckBox cannot be resolved to a type."
      + "\nThe method getViewOfGUIElement is undefined for the type CustomActionTemplate"
      + "\nThe method resolveViewGUIElement is undefined for the type CustomActionTemplate"
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\n!= cannot be resolved."
      + "\nThe method length is undefined for the type CustomActionTemplate"
      + "\nThe method resolveViewGUIElement is undefined for the type CustomActionTemplate"
      + "\nThe method getPathTailAsList is undefined for the type CustomActionTemplate"
      + "\n+ cannot be resolved."
      + "\nreferencedViewField cannot be resolved"
      + "\n== cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\n&& cannot be resolved"
      + "\n!= cannot be resolved"
      + "\nreferencedViewField cannot be resolved"
      + "\npathDefinition cannot be resolved"
      + "\ntail cannot be resolved"
      + "\npathDefinition cannot be resolved"
      + "\ncontentProviderRef cannot be resolved"
      + "\ntype cannot be resolved"
      + "\npathDefinition cannot be resolved"
      + "\ncontentProviderRef cannot be resolved"
      + "\npathDefinition cannot be resolved"
      + "\ncontentProviderRef cannot be resolved"
      + "\npathDefinition cannot be resolved"
      + "\ncontentProviderRef cannot be resolved"
      + "\neClass cannot be resolved"
      + "\nname cannot be resolved");
  }
  
  private CharSequence _generateCodeFragment(final /* UnmappingTask */Object task) {
    org.eclipse.xtend2.lib.StringConcatenation _builder = new org.eclipse.xtend2.lib.StringConcatenation();
    _builder.append("// TODO UnmappingTask");
    _builder.newLine();
    return _builder;
  }
  
  private CharSequence _generateCodeFragment(final /* CallTask */Object task) {
    throw new Error("Unresolved compilation problems:"
      + "\nActionReference cannot be resolved to a type."
      + "\nSimpleActionRef cannot be resolved to a type."
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\naction cannot be resolved"
      + "\nactionRef cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\naction cannot be resolved");
  }
  
  private CharSequence _generateCodeFragment(final /* EventBindingTask */Object task) {
    throw new Error("Unresolved compilation problems:"
      + "\nActionReference cannot be resolved to a type."
      + "\nSimpleActionRef cannot be resolved to a type."
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nevents cannot be resolved"
      + "\nactions cannot be resolved"
      + "\nactionRef cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\naction cannot be resolved"
      + "\neClass cannot be resolved"
      + "\nname cannot be resolved"
      + "\n+ cannot be resolved"
      + "\naction cannot be resolved"
      + "\naction cannot be resolved");
  }
  
  private CharSequence _generateCodeFragment(final /* EventUnbindTask */Object task) {
    throw new Error("Unresolved compilation problems:"
      + "\nActionReference cannot be resolved to a type."
      + "\nSimpleActionRef cannot be resolved to a type."
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nevents cannot be resolved"
      + "\nactions cannot be resolved"
      + "\nactionRef cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\naction cannot be resolved"
      + "\neClass cannot be resolved"
      + "\nname cannot be resolved"
      + "\n+ cannot be resolved"
      + "\naction cannot be resolved");
  }
  
  private Object _generateCodeFragment(final /* ValidatorBindingTask */Object task) {
    throw new Error("Unresolved compilation problems:"
      + "\nreferencedFields cannot be resolved"
      + "\nmap cannot be resolved"
      + "\nfilter cannot be resolved"
      + "\n!= cannot be resolved"
      + "\njoin cannot be resolved");
  }
  
  private CharSequence generateValidatorBindingFragment(final /* ValidatorBindingTask */Object task, final /* AbstractViewGUIElementRef */Object abstractView) {
    throw new Error("Unresolved compilation problems:"
      + "\nStandardValidatorType cannot be resolved to a type."
      + "\nThe method getViewOfGUIElement is undefined for the type CustomActionTemplate"
      + "\nThe method resolveViewGUIElement is undefined for the type CustomActionTemplate"
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\n!= cannot be resolved."
      + "\nThe method length is undefined for the type CustomActionTemplate"
      + "\nThe method resolveViewGUIElement is undefined for the type CustomActionTemplate"
      + "\nStandardValidatorType cannot be resolved to a type."
      + "\n== cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\n&& cannot be resolved"
      + "\n!= cannot be resolved"
      + "\nvalidators cannot be resolved"
      + "\nvalidator cannot be resolved");
  }
  
  private CharSequence _generateCodeFragment(final /* ValidatorUnbindTask */Object task) {
    org.eclipse.xtend2.lib.StringConcatenation _builder = new org.eclipse.xtend2.lib.StringConcatenation();
    _builder.append("// TODO ValidatorUnbindTask");
    _builder.newLine();
    return _builder;
  }
  
  private CharSequence textViewMapTask(final /* ContentProvider */Object contentProviderRef, final String entityClass, final /* TextInput */Object view, final /* List<Attribute> */Object attributePath) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method join is undefined for the type CustomActionTemplate"
      + "\nThe method last is undefined for the type CustomActionTemplate"
      + "\nThe method join is undefined for the type CustomActionTemplate"
      + "\nThe method last is undefined for the type CustomActionTemplate"
      + "\nThe method last is undefined for the type CustomActionTemplate"
      + "\nThe method last is undefined for the type CustomActionTemplate"
      + "\n!= cannot be resolved."
      + "\n> cannot be resolved."
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nequals cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\nequals cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\n&& cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved");
  }
  
  private CharSequence spinnerMapTask(final /* ContentProvider */Object contentProviderRef, final String entityClass, final /* OptionInput */Object view, final /* List<Attribute> */Object attributePath) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method join is undefined for the type CustomActionTemplate"
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved");
  }
  
  private CharSequence checkBoxMapTask(final /* ContentProvider */Object contentProviderRef, final String entityClass, final /* CheckBox */Object view, final /* List<Attribute> */Object attributePath) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method join is undefined for the type CustomActionTemplate"
      + "\nThe method last is undefined for the type CustomActionTemplate"
      + "\nThe method join is undefined for the type CustomActionTemplate"
      + "\nThe method last is undefined for the type CustomActionTemplate"
      + "\nThe method last is undefined for the type CustomActionTemplate"
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nequals cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\nequals cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved");
  }
  
  private String getTextViewMappingType(final /* Attribute */Object attribute) {
    throw new Error("Unresolved compilation problems:"
      + "\nIntegerType cannot be resolved to a type."
      + "\nFloatType cannot be resolved to a type."
      + "\nStringType cannot be resolved to a type."
      + "\nDateType cannot be resolved to a type."
      + "\nTimeType cannot be resolved to a type."
      + "\nDateTimeType cannot be resolved to a type."
      + "\ntype cannot be resolved");
  }
  
  private CharSequence getSimpleActionCode(final /* SimpleAction */Object simpleAction) {
    throw new Error("Unresolved compilation problems:"
      + "\nGotoNextWorkflowStepAction cannot be resolved to a type."
      + "\nGotoPreviousWorkflowStepAction cannot be resolved to a type."
      + "\nGotoWorkflowStepAction cannot be resolved to a type."
      + "\nGotoViewAction cannot be resolved to a type."
      + "\nDataAction cannot be resolved to a type."
      + "\nNewObjectAtContentProviderAction cannot be resolved to a type."
      + "\nAssignObjectAtContentProviderAction cannot be resolved to a type."
      + "\nGPSUpdateAction cannot be resolved to a type."
      + "\nSetActiveWorkflowAction cannot be resolved to a type."
      + "\nThe method resolveViewGUIElement is undefined for the type CustomActionTemplate"
      + "\nAllowedOperation cannot be resolved to a type."
      + "\nAllowedOperation cannot be resolved to a type."
      + "\nAllowedOperation cannot be resolved to a type."
      + "\nThe method getPathTailAsList is undefined for the type CustomActionTemplate"
      + "\nThe method path is undefined for the type CustomActionTemplate"
      + "\nThe method path is undefined for the type CustomActionTemplate"
      + "\nThe method contentProvider is undefined for the type CustomActionTemplate"
      + "\npcStep cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\nsilentFails cannot be resolved"
      + "\nview cannot be resolved"
      + "\ncontentProvider cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\noperation cannot be resolved"
      + "\nCREATE_OR_UPDATE cannot be resolved"
      + "\nREAD cannot be resolved"
      + "\nDELETE cannot be resolved"
      + "\ncontentProvider cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\nbindings cannot be resolved"
      + "\ntail cannot be resolved"
      + "\njoin cannot be resolved"
      + "\nequals cannot be resolved"
      + "\nlast cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\ncontentProviderRef cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\nworkflow cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved");
  }
  
  private CharSequence getGPSUpdateCode(final /* GPSUpdateAction */Object action) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method entries is undefined for the type CustomActionTemplate"
      + "\nThe method getPathTailAsList is undefined for the type CustomActionTemplate"
      + "\nThe method path is undefined for the type CustomActionTemplate"
      + "\nThe method path is undefined for the type CustomActionTemplate"
      + "\nThe method path is undefined for the type CustomActionTemplate"
      + "\nbindings cannot be resolved"
      + "\ntail cannot be resolved"
      + "\njoin cannot be resolved"
      + "\nequals cannot be resolved"
      + "\nlast cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\ncontentProviderRef cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\nlast cannot be resolved"
      + "\ncontentProviderRef cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved");
  }
  
  private CharSequence resolveGPSActionEntityBindingEntry(final /* GPSActionEntityBindingEntry */Object entry) {
    throw new Error("Unresolved compilation problems:"
      + "\nGPSField cannot be resolved to a type."
      + "\nGPSField cannot be resolved to a type."
      + "\nGPSField cannot be resolved to a type."
      + "\nGPSField cannot be resolved to a type."
      + "\nGPSField cannot be resolved to a type."
      + "\nGPSField cannot be resolved to a type."
      + "\nGPSField cannot be resolved to a type."
      + "\nGPSField cannot be resolved to a type."
      + "\nGPSField cannot be resolved to a type."
      + "\nGPSField cannot be resolved to a type."
      + "\nGPSField cannot be resolved to a type."
      + "\nGPSField cannot be resolved to a type."
      + "\nstring cannot be resolved"
      + "\n!= cannot be resolved"
      + "\nstring cannot be resolved"
      + "\ngpsField cannot be resolved"
      + "\nLATITUDE cannot be resolved"
      + "\nLONGITUDE cannot be resolved"
      + "\nALTITUDE cannot be resolved"
      + "\nCITY cannot be resolved"
      + "\nSTREET cannot be resolved"
      + "\nNUMBER cannot be resolved"
      + "\nPOSTAL_CODE cannot be resolved"
      + "\nCOUNTRY cannot be resolved"
      + "\nPROVINCE cannot be resolved"
      + "\ngpsField cannot be resolved"
      + "\n!= cannot be resolved"
      + "\nLATITUDE cannot be resolved"
      + "\n&& cannot be resolved"
      + "\ngpsField cannot be resolved"
      + "\n!= cannot be resolved"
      + "\nLONGITUDE cannot be resolved"
      + "\n&& cannot be resolved"
      + "\ngpsField cannot be resolved"
      + "\n!= cannot be resolved"
      + "\nALTITUDE cannot be resolved");
  }
  
  public CharSequence getStringConversion(final /* Attribute */Object attribute, final String string) {
    throw new Error("Unresolved compilation problems:"
      + "\nStringType cannot be resolved to a type."
      + "\nIntegerType cannot be resolved to a type."
      + "\nFloatType cannot be resolved to a type."
      + "\ntype cannot be resolved");
  }
  
  private Object getUniqueSimpleActionIdentifier(final /* SimpleAction */Object simpleAction) {
    throw new Error("Unresolved compilation problems:"
      + "\nGotoNextWorkflowStepAction cannot be resolved to a type."
      + "\nGotoPreviousWorkflowStepAction cannot be resolved to a type."
      + "\nGotoWorkflowStepAction cannot be resolved to a type."
      + "\nGotoViewAction cannot be resolved to a type."
      + "\nDataAction cannot be resolved to a type."
      + "\nNewObjectAtContentProviderAction cannot be resolved to a type."
      + "\nGPSUpdateAction cannot be resolved to a type."
      + "\nSetActiveWorkflowAction cannot be resolved to a type."
      + "\nAssignObjectAtContentProviderAction cannot be resolved to a type."
      + "\n+ cannot be resolved."
      + "\n+ cannot be resolved."
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nThe method resolveViewGUIElement is undefined for the type CustomActionTemplate"
      + "\n+ cannot be resolved."
      + "\nAllowedOperation cannot be resolved to a type."
      + "\nAllowedOperation cannot be resolved to a type."
      + "\nAllowedOperation cannot be resolved to a type."
      + "\n+ cannot be resolved."
      + "\nThe method getReferencedAttribute is undefined for the type CustomActionTemplate"
      + "\nThe method path is undefined for the type CustomActionTemplate"
      + "\n+ cannot be resolved."
      + "\n+ cannot be resolved."
      + "\nThe method getPathTailAsString is undefined for the type CustomActionTemplate"
      + "\npcStep cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\nview cannot be resolved"
      + "\ncontentProvider cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\n+ cannot be resolved"
      + "\n+ cannot be resolved"
      + "\noperation cannot be resolved"
      + "\nCREATE_OR_UPDATE cannot be resolved"
      + "\nREAD cannot be resolved"
      + "\nDELETE cannot be resolved"
      + "\ncontentProvider cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\nbindings cannot be resolved"
      + "\nname cannot be resolved"
      + "\nworkflow cannot be resolved"
      + "\nname cannot be resolved"
      + "\ntoFirstUpper cannot be resolved"
      + "\nbindings cannot be resolved"
      + "\njoin cannot be resolved"
      + "\ncontentProvider cannot be resolved"
      + "\nname cannot be resolved"
      + "\n+ cannot be resolved"
      + "\n+ cannot be resolved"
      + "\npath cannot be resolved"
      + "\ntail cannot be resolved");
  }
  
  private CharSequence getSimpleActionAsEventHandler(final /* SimpleAction */Object simpleAction) {
    org.eclipse.xtend2.lib.StringConcatenation _builder = new org.eclipse.xtend2.lib.StringConcatenation();
    _builder.append("new MD2EventHandler() {");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("@Override");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("public void eventOccured() {");
    _builder.newLine();
    _builder.append("\t\t");
    CharSequence _simpleActionCode = this.getSimpleActionCode(simpleAction);
    _builder.append(_simpleActionCode, "		");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.append("}");
    _builder.newLine();
    _builder.append("}");
    _builder.newLine();
    return _builder;
  }
  
  private CharSequence _generateStandardValidator(final /* StandardIsIntValidator */Object validator, final /* ViewGUIElement */Object viewElem) {
    throw new Error("Unresolved compilation problems:"
      + "\nValidatorMessageParam cannot be resolved to a type."
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nTextInput cannot be resolved to a type."
      + "\nparams cannot be resolved"
      + "\nfilter cannot be resolved"
      + "\nlast cannot be resolved"
      + "\nmessage cannot be resolved"
      + "\neClass cannot be resolved"
      + "\nname cannot be resolved");
  }
  
  private CharSequence _generateStandardValidator(final /* StandardNotNullValidator */Object validator, final /* ViewGUIElement */Object viewElem) {
    throw new Error("Unresolved compilation problems:"
      + "\nValidatorMessageParam cannot be resolved to a type."
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nTextInput cannot be resolved to a type."
      + "\nparams cannot be resolved"
      + "\nfilter cannot be resolved"
      + "\nlast cannot be resolved"
      + "\nmessage cannot be resolved"
      + "\neClass cannot be resolved"
      + "\nname cannot be resolved");
  }
  
  private CharSequence _generateStandardValidator(final /* StandardIsNumberValidator */Object validator, final /* ViewGUIElement */Object viewElem) {
    throw new Error("Unresolved compilation problems:"
      + "\nValidatorMessageParam cannot be resolved to a type."
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nTextInput cannot be resolved to a type."
      + "\nparams cannot be resolved"
      + "\nfilter cannot be resolved"
      + "\nlast cannot be resolved"
      + "\nmessage cannot be resolved"
      + "\neClass cannot be resolved"
      + "\nname cannot be resolved");
  }
  
  private CharSequence _generateStandardValidator(final /* StandardIsDateValidator */Object validator, final /* ViewGUIElement */Object viewElem) {
    throw new Error("Unresolved compilation problems:"
      + "\nValidatorFormatParam cannot be resolved to a type."
      + "\nValidatorMessageParam cannot be resolved to a type."
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nTextInput cannot be resolved to a type."
      + "\nparams cannot be resolved"
      + "\nfilter cannot be resolved"
      + "\nlast cannot be resolved"
      + "\n== cannot be resolved"
      + "\nformat cannot be resolved"
      + "\nparams cannot be resolved"
      + "\nfilter cannot be resolved"
      + "\nlast cannot be resolved"
      + "\nmessage cannot be resolved"
      + "\neClass cannot be resolved"
      + "\nname cannot be resolved");
  }
  
  private CharSequence _generateStandardValidator(final /* StandardRegExValidator */Object validator, final /* ViewGUIElement */Object viewElem) {
    throw new Error("Unresolved compilation problems:"
      + "\nValidatorRegExParam cannot be resolved to a type."
      + "\nValidatorMessageParam cannot be resolved to a type."
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nTextInput cannot be resolved to a type."
      + "\nparams cannot be resolved"
      + "\nfilter cannot be resolved"
      + "\nlast cannot be resolved"
      + "\n== cannot be resolved"
      + "\nregEx cannot be resolved"
      + "\nreplaceAll cannot be resolved"
      + "\nreplaceAll cannot be resolved"
      + "\nparams cannot be resolved"
      + "\nfilter cannot be resolved"
      + "\nlast cannot be resolved"
      + "\nmessage cannot be resolved"
      + "\neClass cannot be resolved"
      + "\nname cannot be resolved");
  }
  
  private CharSequence _generateStandardValidator(final /* StandardNumberRangeValidator */Object validator, final /* ViewGUIElement */Object viewElem) {
    throw new Error("Unresolved compilation problems:"
      + "\nValidatorMaxParam cannot be resolved to a type."
      + "\nValidatorMinParam cannot be resolved to a type."
      + "\nValidatorMessageParam cannot be resolved to a type."
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nTextInput cannot be resolved to a type."
      + "\nparams cannot be resolved"
      + "\nfilter cannot be resolved"
      + "\nlast cannot be resolved"
      + "\nparams cannot be resolved"
      + "\nfilter cannot be resolved"
      + "\nlast cannot be resolved"
      + "\n== cannot be resolved"
      + "\nmax cannot be resolved"
      + "\n== cannot be resolved"
      + "\nmin cannot be resolved"
      + "\nparams cannot be resolved"
      + "\nfilter cannot be resolved"
      + "\nlast cannot be resolved"
      + "\nmessage cannot be resolved"
      + "\neClass cannot be resolved"
      + "\nname cannot be resolved");
  }
  
  private CharSequence _generateStandardValidator(final /* StandardStringRangeValidator */Object validator, final /* ViewGUIElement */Object viewElem) {
    throw new Error("Unresolved compilation problems:"
      + "\nValidatorMaxLengthParam cannot be resolved to a type."
      + "\nValidatorMinLengthParam cannot be resolved to a type."
      + "\nValidatorMessageParam cannot be resolved to a type."
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\nTextInput cannot be resolved to a type."
      + "\nparams cannot be resolved"
      + "\nfilter cannot be resolved"
      + "\nlast cannot be resolved"
      + "\nparams cannot be resolved"
      + "\nfilter cannot be resolved"
      + "\nlast cannot be resolved"
      + "\n== cannot be resolved"
      + "\nmaxLength cannot be resolved"
      + "\n== cannot be resolved"
      + "\nminLength cannot be resolved"
      + "\nparams cannot be resolved"
      + "\nfilter cannot be resolved"
      + "\nlast cannot be resolved"
      + "\nmessage cannot be resolved"
      + "\neClass cannot be resolved"
      + "\nname cannot be resolved");
  }
  
  private String getTypeName(final /* DataType */Object dataType) {
    throw new Error("Unresolved compilation problems:"
      + "\nSimpleType cannot be resolved to a type."
      + "\nSimpleType cannot be resolved to a type."
      + "\nReferencedModelType cannot be resolved to a type."
      + "\nReferencedModelType cannot be resolved to a type."
      + "\nSimpleDataType cannot be resolved to a type."
      + "\nSimpleDataType cannot be resolved to a type."
      + "\nSimpleDataType cannot be resolved to a type."
      + "\nSimpleDataType cannot be resolved to a type."
      + "\nSimpleDataType cannot be resolved to a type."
      + "\nSimpleDataType cannot be resolved to a type."
      + "\nSimpleDataType cannot be resolved to a type."
      + "\n+ cannot be resolved."
      + "\nThe method getName is undefined for the type CustomActionTemplate"
      + "\ntype cannot be resolved"
      + "\nBOOLEAN cannot be resolved"
      + "\nDATE cannot be resolved"
      + "\nDATE_TIME cannot be resolved"
      + "\nTIME cannot be resolved"
      + "\nFLOAT cannot be resolved"
      + "\nINTEGER cannot be resolved"
      + "\nSTRING cannot be resolved"
      + "\n+ cannot be resolved"
      + "\nentity cannot be resolved"
      + "\ntoFirstUpper cannot be resolved");
  }
  
  private CharSequence generateCodeFragment(final MappingTask task) {
    if (task != null) {
      return _generateCodeFragment(task);
    } else {
      throw new IllegalArgumentException("Unhandled parameter types: " +
        Arrays.<Object>asList(task).toString());
    }
  }
  
  private CharSequence generateStandardValidator(final StandardIsIntValidator validator, final ViewGUIElement viewElem) {
    if (validator != null
         && viewElem != null) {
      return _generateStandardValidator(validator, viewElem);
    } else {
      throw new IllegalArgumentException("Unhandled parameter types: " +
        Arrays.<Object>asList(validator, viewElem).toString());
    }
  }
}
