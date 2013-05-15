// static: EventHandling
//
//  EventHandler.h
//  Tarifrechner
//
//  Created by Uni Münster on 18.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "AppDelegate.h"
#import "EventHandlerProtocols.h"

@interface EventHandler : NSObject <AppDelegateWidgetDelegate>
{
    id<EventHandlerComboboxDelegate> eventHandlerComboboxDelegate;
    id<EventHandlerEntitySelectorDelegate> eventHandlerEntitySelectorDelegate;
    id<EventHandlerCheckboxDelegate> eventHandlerCheckboxDelegate;
    id<EventHandlerInfoButtonDelegate> eventHandlerInfoButtonDelegate;
    id<EventHandlerTextFieldDelegate> eventHandlerTextFieldDelegate;
    id<EventHandlerPopoverDelegate> eventHandlerPopoverDelegate;
    
    AppDelegate *appDelegate;
}

@property (retain, nonatomic) id<EventHandlerComboboxDelegate> eventHandlerComboboxDelegate;
@property (retain, nonatomic) id<EventHandlerEntitySelectorDelegate> eventHandlerEntitySelectorDelegate;
@property (retain, nonatomic) id<EventHandlerCheckboxDelegate> eventHandlerCheckboxDelegate;
@property (retain, nonatomic) id<EventHandlerInfoButtonDelegate> eventHandlerInfoButtonDelegate;
@property (retain, nonatomic) id<EventHandlerTextFieldDelegate> eventHandlerTextFieldDelegate;
@property (retain, nonatomic) id<EventHandlerPopoverDelegate> eventHandlerPopoverDelegate;

+(EventHandler *) instance;

@end