// static: Widgets
//
//  CheckboxWidget.h
//  Tarifrechner
//
//  Created by Uni Münster on 18.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "EventHandler.h"

@interface CheckboxWidget : Widget <EventHandlerCheckboxDelegate>
{
    UISwitch *viewSwitch;
    BOOL isEnabled;
    EventHandler *eventHandler;
}

@end