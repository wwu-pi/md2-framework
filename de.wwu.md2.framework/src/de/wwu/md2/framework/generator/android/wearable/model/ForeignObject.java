package de.wwu.md2.framework.generator.android.wearable.model;

public class ForeignObject {

	private String className;
	private String attributeName;
	private String targetClass;
	public String getClassName() {
		return className;
	}
	public void setClassName(String className) {
		this.className = className;
	}
	public String getAttributeName() {
		return attributeName;
	}
	public void setAttributeName(String attributeName) {
		this.attributeName = attributeName;
	}
	public ForeignObject(String className, String attributeName, String targetClass) {
		super();
		this.className = className;
		this.attributeName = attributeName;
		this.targetClass=targetClass;
	}
	public String getTargetClass() {
		return targetClass;
	}
	public void setTargetClass(String targetClass) {
		this.targetClass = targetClass;
	}
	
	
}
