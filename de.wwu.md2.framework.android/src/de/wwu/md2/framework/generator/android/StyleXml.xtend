package de.wwu.md2.framework.generator.android

class StyleXml {
	def static generateStyleXml() '''
		<?xml version="1.0" encoding="utf-8"?>
		<resources>
		    <style name="ContainerDefault">
		        <item name="android:layout_width">match_parent</item>
		        <item name="android:layout_height">wrap_content</item>
		        <item name="android:layout_weight">1</item>
		    </style>
		    
		    <style name="ContentDefault">
		        <item name="android:layout_width">wrap_content</item>
		        <item name="android:layout_height">wrap_content</item>
		        <item name="android:layout_weight">1</item>
		    </style>
		    
		    <style name="ContentDefault.EditTextDefault">
		        <item name="android:layout_width">150dp</item>
		    </style>
		    
		    <style name="ContentDefault.ToolTipDefault">
				<item name="android:layout_height">match_parent</item>
		        <item name="android:layout_weight">0</item>
		        <item name="android:background">@null</item>
		        <item name="android:src">@drawable/information</item>
		    </style>
		</resources>
	'''
}