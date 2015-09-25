//
//  MD2ViewConfig.swift
//  md2-ios-library
//
//  Created by Christoph Rieger on 03.08.15.
//  Copyright (c) 2015 Christoph Rieger. All rights reserved.
//

/// Configuration values for the app's view
class MD2ViewConfig {
    
    /// Default distance between elements in pixels
    static let GUTTER: Float = 5.0
    
    /// Default font name
    static let FONT_NAME: MD2WidgetTextStyle = MD2WidgetTextStyle.Normal
	/// Default font size
    static let FONT_SIZE: Int = 12
    
    /// Default placeholder text for option widgets
    static let OPTION_WIDGET_PLACEHOLDER = " - Please select -"
    
    /// Time format
    static let TIME_FORMAT = "HH:mm:ss"
	/// Date format
    static let DATE_FORMAT = "yyyy-MM-dd"
	/// DateTime format
    static let DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm:ss"
    
    /// Tooltip title for information popups
    static let TOOLTIP_TITLE_INFO = "Info"
	/// Tooltip title for message popups
    static let TOOLTIP_TITLE_MESSAGE = "Message"
	/// Tooltip popup button caption
    static let TOOLTIP_BUTTON = "OK"
	/// Default size for tooltip hint 
    static let TOOLTIP_WIDTH: Float = 35.0
    
    /// Default height of a text input field
    static let DIMENSION_TEXTFIELD_HEIGHT: Float = 50.0
	/// Default height of a label
    static let DIMENSION_LABEL_HEIGHT: Float = 50.0
	/// Default height of a spacer
    static let DIMENSION_SPACER_HEIGHT: Float = 50.0
	/// Default height of a button
    static let DIMENSION_BUTTON_HEIGHT: Float = 50.0
	/// Default height of a date time picker widget
    static let DIMENSION_DATE_TIME_PICKER_HEIGHT: Float = 50.0
	/// Default height of an option picker widget
    static let DIMENSION_OPTION_HEIGHT: Float = 50.0
	/// Default height of a switch widget
    static let DIMENSION_SWITCH_HEIGHT: Float = 50.0
	/// Default height of an image element
    static let DIMENSION_IMAGE_HEIGHT: Float = 150.0
    
}