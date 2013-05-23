// static: Widgets
//
//  EntitySelectorWidget.h
//  TariffCalculator
//
//  Created by Uni Münster on 23.07.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Widget.h"
#import "ComboboxWidget.h"

@interface EntitySelectorWidget : Widget <EventHandlerEntitySelectorDelegate>
{
    ComboboxWidget *comboboxWidget;
    NSString *textProposition;
    BOOL isEnabled;
    EventHandler *eventHandler;
}

@property (retain, nonatomic) NSString *textProposition;
@property (retain, nonatomic) ComboboxWidget *comboboxWidget;

-(void) setOptions: (NSArray *) options;

@end