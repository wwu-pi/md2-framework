// static: Controllers
//
//  Controller.m
//  TariffCalculator
//
//	The Controller encapsulates the business logic for a given view and fills the application with data.
//	Also, it is used as an fassade to access business logic and the data model.
//
//  Created by Uni Muenster on 01.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Controller.h"
#import "ComboboxWidget.h"
#import "EntitySelectorWidget.h"

@interface Controller ()
@end

@implementation Controller

/*
*	Implementation of the getters and setters of the instance attributes.
*/
@synthesize dataMapper;

#pragma mark Initialization Methods

/*
*	Initializes the Controller object.
*/
-(id) init
{
    self = [super init];
    if (self)
    {
        contentView = [[View alloc] init];
        dataMapper = [[DataMapper alloc] init];
    }
    return [super init];
}

#pragma mark Loading Methods

/*
*	Loads the view of the Controller.
*/
-(void) loadView
{
    [super loadView];
    [contentView loadView];
    contentView.frame = ContentViewFrame;
    [self setView: contentView];
}

/*
*	Will be overridden to automatically load the data.
*/
-(void) viewDidLoad
{
    [self loadData];
}

/*
*	Loads the data of the Controller.
*/
-(void) loadData
{
    NSSet *widgets = [contentView getAllWidgets];
    for (Widget *widget in widgets)
    {
        //EntitySelectorWidgets and ComboboxWidgets are handled seperately
        if ([widget class] != [EntitySelectorWidget class])
        {
            NSString *data = [dataMapper getDataByIdentifier: widget.identifier];
            if (data != nil)
                [widget setData: data];
        }
        //TODO: Add replacement of predicate before data loading
        else
            ;
    }
    
    NSSet *comboboxWidgets = [contentView getAllComboboxWidgets];
    for (ComboboxWidget *comboboxWidget in comboboxWidgets)
    {
        NSString *data = nil;
        if (!comboboxWidget.hasDatePicker && !comboboxWidget.hasTimePicker)
        {
            data = [dataMapper getEnumStringByIdentifier: comboboxWidget.identifier value: [DataConverter getNumberByString: comboboxWidget.data]];
            if (!comboboxWidget.hasStaticContent)
                [comboboxWidget setOptions: [NSMutableArray arrayWithArray: [dataMapper getAllEnumValuesByIdentifier: comboboxWidget.identifier]]];
        }
        else if (comboboxWidget.hasDatePicker && !comboboxWidget.hasTimePicker)
            data = [DataConverter getDateStringByString: [dataMapper getDataByIdentifier: comboboxWidget.identifier]];
        else if (!comboboxWidget.hasDatePicker && comboboxWidget.hasTimePicker)
            data = [DataConverter getTimeStringByString: [dataMapper getDataByIdentifier: comboboxWidget.identifier]];
        else if (comboboxWidget.hasDatePicker && comboboxWidget.hasTimePicker)
            data = [dataMapper getDataByIdentifier: comboboxWidget.identifier];
        
        if (data != nil)
            [comboboxWidget setData: data];
        if (comboboxWidget.hasStaticContent)
            [comboboxWidget setData: [comboboxWidget.options objectAtIndex: 0]];
    }
    
    NSSet *entitySelectorWidgets = [contentView getAllEntitySelectorWidgets];
    for (EntitySelectorWidget *entitySelectorWidget in entitySelectorWidgets)
    {
        NSSet *data = [dataMapper getDataByIdentifier: entitySelectorWidget.identifier];
        
        NSMutableArray *stringData = [[NSMutableArray alloc] init];
        for (NSManagedObject *object in data)
            [stringData addObject: [object valueForKey: entitySelectorWidget.textProposition]];
        
        NSManagedObject *currentObject = [dataMapper getCurrentDataObjectByIdentifier: entitySelectorWidget.identifier];
        
        if (currentObject == nil)
            currentObject = [data anyObject];
        
        if (stringData != nil && stringData.count > 0 && currentObject != nil)
        {
            [entitySelectorWidget setOptions: stringData];
            [entitySelectorWidget setData: [currentObject valueForKey: entitySelectorWidget.textProposition]];
        }
    }
}

#pragma mark Write Methods

/*
*	Writes the combobox selection with the help of the data mapper.
*/
-(void) writeComboBoxSelection: (id) selection identifier: (NSString *) identifier
{
    [dataMapper setDataByIdentifier: selection identifier: identifier];
}

/*
 *	Writes the checkbox value with the help of the data mapper.
 */
-(void) writeCheckboxValue: (BOOL) isEnabled identifier: (NSString *) identifier
{
    [dataMapper setDataByIdentifier: [NSNumber numberWithBool: isEnabled] identifier: identifier];
}

/*
 *	Writes the entity selector selectionb with the help of the data mapper.
 */
-(void) writeEntitySelectorSelection: (id) selection identifier: (NSString *) identifier
{
    [dataMapper setDataByIdentifier: selection identifier: identifier];
}

/*
*	Writes the text field text with the help of the data mapper.
*/
-(void) writeTextFieldText: (id) text identifier: (NSString *) identifier
{
    [dataMapper setDataByIdentifier: text identifier: identifier];
}

/*
*	Persists the data with the help of the data mapper.
*/
-(void) persistData
{
    NSSet *widgets = [contentView getAllWidgets];
    for (Widget *widget in widgets)
        [widget persistData];
    [dataMapper writeDataObject];
}

#pragma mark Unloading Methods

/*
*	Unloads the view and deallocates the view and data mapper.
*/
-(void) viewDidUnload
{
    contentView = nil;
    dataMapper = nil;
    
    [super viewDidUnload];
}

#pragma mark Workflow Methods

/*
*	Returns the view by a specific identifier.
*/
-(UIView *) getViewByIdentifier: (NSString *) identifier
{
    return [contentView getViewByIdentifier: identifier];
}

/*
*	Checks the widget validity by a specific identifier.
*/
-(BOOL) checkWidgetValidityByIdentifier: (NSString *) identifier
{
    NSSet *widgets = [contentView getWidgetByIdentifier: identifier];
    if (widgets.count > 0)
    {
        for (Widget *widget in widgets)
            if (![widget.validation checkAllValidatorsByStringData: widget.data])
                return NO;
    }
    else
    {
        NSSet *widgets = [contentView getAllWidgets];
        if (widgets.count > 0)
        {
            for (Widget *widget in widgets)
                if (![widget.validation checkAllValidatorsByStringData: widget.data])
                    return NO;
        }
    }
    return YES;
}

/*
*	Checks the widget data by a specific identifier.
*/
-(BOOL) checkWidgetDataByIdentifier: (NSString *) identifier data: (NSString *) data
{
    NSSet *widgets = [contentView getWidgetByIdentifier: identifier];
    for (Widget *widget in widgets)
        if (![widget.data isEqualToString: data])
            return NO;
    return YES;
}

/*
*	Returns the widget data by a specific identifier.
*/
-(NSString *) getWidgetDataByIdentifier: (NSString *) identifier
{
    NSSet *widgets = [contentView getWidgetByIdentifier: identifier];
    return ((Widget *) [widgets anyObject]).data;
}

#pragma mark Screen orientation adjustments

/*
*	Determines the behavior for screen rotations.
*/
-(BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft)||(interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

@end