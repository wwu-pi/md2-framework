package de.wwu.md2.framework.generator.android.common.templates;

public class ContentAdder {
	private CharSequence content;

	public void operator_doubleLessThan(CharSequence c) {
		this.content = c;
	}

	public CharSequence getContent() {
		return content;
	}

}
