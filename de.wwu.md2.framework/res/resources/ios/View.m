// static: Views
//
//  View.m
//  TariffCalculator
//
//	The View represents the superclass for all full-screen UIViews.
//	Therefore, the needed methods will be defined.
//
//  Created by Uni Muenster on 01.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "View.h"
#import "Widget.h"
#import "WidgetFactory.h"
#import "FlowLayout.h"

@implementation View

@synthesize identifier;

#pragma mark Initialization Methods

/*
*	Initializes the View object.
*/
-(id) init
{
    self = [super init];
    if (self)
    {
        [self initializeTriggers];
        
        hasContentInsets = YES;
        identifier = @"";
        widgets = [[NSMutableSet alloc] init];
        layouts = [[NSMutableSet alloc] init];
    }
    return self;
}

/*
*	Loads the View object and sets all components appropriately.
*/
-(void) loadView
{
    (void)[self initWithFrame: MainFrame];
    self.backgroundColor = [UIColor whiteColor];
    
    contentView = [[UIScrollView alloc] initWithFrame: ScrollViewFrame];
    contentView.alwaysBounceVertical = YES;
    contentView.scrollEnabled = YES;
    contentView.contentSize = ContentViewSize;
    contentView.contentInset = (hasContentInsets)? ContentInsets: UIEdgeInsetsZero;
    [contentView setContentOffset: (hasContentInsets)? ContentOffset: CGPointZero animated: NO];
    contentView.scrollsToTop = YES;
    
    defaultLayout = [[FlowLayout alloc] initWithFrame: LayoutFrame(self.bounds)];
    
    defaultLayout.frame = ContentFrame;
    [contentView addSubview: defaultLayout];
    [self addSubview: contentView];
}

#pragma mark Widget Adding Methods

/*
*	Adds a widget to the default layout.
*/
-(void) addWidget: (Widget *) widget
{
    [self addWidget: widget toLayout: defaultLayout];
}

/*
*	Adds a widget to a specific layout.
*/
-(void) addWidget: (Widget *) widget toLayout: (Layout *) layout
{
    [widgets addObject: widget];
    if (![layouts containsObject: layout])
        [layouts addObject: layout];
    widget = [widget initWithFrame: DefaultWidgetFrame(widget.frame)];
    [layout addView: widget identifier: widget.identifier];
}

/*
*	Adds a view to the default layout by the given identifier.
*/
-(void) addView: (UIView *) view identifier: (NSString *) viewIdentifier
{
    [self addView: view identifier: identifier rowSpan: 1 toLayout: defaultLayout];
}

/*
*	Adds a view to a specific layout by the given identifier.
*/
-(void) addView: (UIView *) view identifier: (NSString *) viewIdentifier toLayout: (Layout *) layout
{
    [self addView: view identifier: identifier rowSpan: 1 toLayout: layout];
}

/*
*	Adds a view with the given row span to the default layout by the given identifier.
*/
-(void) addView: (UIView *) view identifier: (NSString *) viewIdentifier rowSpan: (NSUInteger) rowSpan
{
    [self addView: view identifier: identifier rowSpan: rowSpan toLayout: defaultLayout];
}

/*
*	Adds a view to the default layout at the given row and column by the given identifier.
*/
-(void) addView: (UIView *) view identifier: (NSString *) viewIdentifier rowSpan: (NSUInteger) rowSpan toLayout: (Layout *) layout
{
    [layout addLayout: view identifier: viewIdentifier rowSpan: rowSpan];
    if (![layouts containsObject: layout])
        [layouts addObject: layout];
}

#pragma mark Widget Creating Methods

/*
*	Creates a combobox (no label) by the given identifier, that can have a date or time picker and an info button.
*/
-(id) createCombobox: (NSString *) widgetIdentifier hasDatePicker: (BOOL) hasDatePicker hasTimePicker: (BOOL) hasTimePicker hasInfoButton: (BOOL) hasInfoButton
{
    return [WidgetFactory createComboboxWithIdentifier: widgetIdentifier hasDatePicker: hasDatePicker hasTimePicker: hasTimePicker hasInfoButton: hasInfoButton];
}
/*
 *	Creates a combobox (no label) by the given identifier, that can have an info button attached and a fixed options array.
 */
-(id) createCombobox: (NSString *) widgetIdentifier options: (NSArray *) options hasInfoButton: (BOOL) hasInfoButton
{
    return [WidgetFactory createComboboxWithIdentifier: widgetIdentifier options: options hasInfoButton: hasInfoButton];
}

/*
*	Creates a combobox widget by the given identifier, that can have a date or time picker and an info button.
*/
-(id) createComboboxWidget: (NSString *) widgetIdentifier hasDatePicker: (BOOL) hasDatePicker hasTimePicker: (BOOL) hasTimePicker hasInfoButton: (BOOL) hasInfoButton
{
    return [WidgetFactory createComboboxWidgetWithIdentifier: widgetIdentifier hasDatePicker: hasDatePicker hasTimePicker: hasTimePicker hasInfoButton: hasInfoButton];
}

/*
 *	Creates a combobox widget by the given identifier, that can have an info button attached and a fixed options array.
 */
-(id) createComboboxWidget: (NSString *) widgetIdentifier options: (NSArray *) options hasInfoButton: (BOOL) hasInfoButton
{
    return [WidgetFactory createComboboxWidgetWithIdentifier: widgetIdentifier options: options hasInfoButton: hasInfoButton];
}

/*
*	Creates a text input (no label) by the given identifier, that can have an info button.
*/
-(id) createTextInput: (NSString *) widgetIdentifier hasInfoButton: (BOOL) hasInfoButton
{
    return [WidgetFactory createTextInputWithIdentifier: widgetIdentifier hasInfoButton: hasInfoButton];
}

/*
*	Creates a text input widget by the given identifier, that can have an info button.
*/
-(id) createTextFieldWidget: (NSString *) widgetIdentifier hasInfoButton: (BOOL) hasInfoButton
{
    return [WidgetFactory createTextFieldWidgetWithIdentifier: widgetIdentifier hasInfoButton: hasInfoButton];
}

/*
*	Creates an checkbox widget by the given identifier, that can have an info button.
*/
-(id) createCheckboxWidget: (NSString *) widgetIdentifier hasInfoButton: (BOOL) hasInfoButton
{
    return [WidgetFactory createCheckboxWidgetWithIdentifier: widgetIdentifier hasInfoButton: hasInfoButton];
}

/*
 *	Creates an entity selector widget by the given identifier, textProposition, that can have an info button.
 */
-(id) createEntitySelectorWidget: (NSString *) widgetIdentifier textProposition: (NSString *) textProposition hasInfoButton: (BOOL) hasInfoButton
{
    return [WidgetFactory createEntitySelectorWidgetWithIdentifier: widgetIdentifier textProposition: textProposition hasInfoButton: hasInfoButton];
}

/*
*	Creates a label widget by the given identifier, that can have an info button.
*/
-(id) createLabelWidget: (NSString *) widgetIdentifier hasInfoButton: (BOOL) hasInfoButton
{
    return [WidgetFactory createLabelWidgetWithIdentifier: widgetIdentifier hasInfoButton: hasInfoButton];
}

/*
*	Creates a spacer by the given identifier, that can have an info button.
*/
-(id) createSpacerWidget: (NSString *) widgetIdentifier hasInfoButton: (BOOL) hasInfoButton
{
    return [WidgetFactory createSpacerWidgetWithIdentifier: widgetIdentifier hasInfoButton: hasInfoButton];
}

/*
*	Creates a button by the given identifier.
*/
-(id) createButtonWidget: (NSString *) widgetIdentifier
{
    return [WidgetFactory createButtonWidgetWithIdentifier: widgetIdentifier];
}

/*
*	Creates an image by the given identifier.
*/
-(id) createImageWidget: (NSString *) widgetIdentifier imageName: (NSString *) imagePath
{
    return [WidgetFactory createImageWidgetWithIdentifier: widgetIdentifier imageName: imagePath];
}

/*
*	Replaces a specific view by identifier by a new view and identifier.
*/
#pragma mark View Replacement Methods

-(void) replaceView: (NSString *) oldIdentifier newView: (UIView *) newView newIdentifier: (NSString *) newIdentifier
{
    [defaultLayout replaceView: oldIdentifier newView: newView newIdentifier: newIdentifier];
    for (Widget *widget in widgets)
    {
        if ([widget.identifier isEqualToString: oldIdentifier])
        {
            [widgets removeObject: widget];
            break;
        }
    }
    [widgets addObject: newView];
}

/*
*	Get all widgets of the view.
*/
#pragma mark Widget Accessing Methods

-(NSSet *) getAllWidgets
{
    return widgets;
}

/*
*	Get all non-combobox widgets of the view.
*/
-(NSSet *) getAllNonComboboxWidgets
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"class<>%@", [ComboboxWidget class]];
    return [widgets filteredSetUsingPredicate: predicate];
}

/*
*	Get all combobox widgets of the view.
*/
-(NSSet *) getAllComboboxWidgets
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"class=%@", [ComboboxWidget class]];
    return [widgets filteredSetUsingPredicate: predicate];
}

/*
*	Get all text field widgets of the view.
*/
-(NSSet *) getAllTextFieldWidgets
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"class=%@", [TextFieldWidget class]];
    return [widgets filteredSetUsingPredicate: predicate];
}

/*
*	Get all checkbox widgets of the view.
*/
-(NSSet *) getAllCheckboxWidgets
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"class=%@", [CheckboxWidget class]];
    return [widgets filteredSetUsingPredicate: predicate];
}

/*
 *	Get all entity selector widgets of the view.
 */
-(NSSet *) getAllEntitySelectorWidgets
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"class=%@", [EntitySelectorWidget class]];
    return [widgets filteredSetUsingPredicate: predicate];
}

/*
*	Get all label widgets of the view.
*/
-(NSSet *) getAllLabelWidgets
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"class=%@", [LabelWidget class]];
    return [widgets filteredSetUsingPredicate: predicate];
}

/*
*	Get a specific widget of the view by the given identifier.
*/
-(NSSet *) getWidgetByIdentifier: (NSString *) widgetIdentifier
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"identifier=%@", widgetIdentifier];
    return [widgets filteredSetUsingPredicate: predicate];
}

/*
*	Get a specific UIView of the view by the given identifier.
*/
-(UIView *) getViewByIdentifier: (NSString *) viewIdentifier
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"identifier=%@", viewIdentifier];
    NSSet *filteredElements = [widgets filteredSetUsingPredicate: predicate];
    if (filteredElements.count > 0)
        return filteredElements.anyObject;
    
    filteredElements = [layouts filteredSetUsingPredicate: predicate];
    if (filteredElements.count > 0)
        return filteredElements.anyObject;
    
    if ([self.identifier isEqualToString: viewIdentifier])
        return self;
    
    return nil;
}

@end