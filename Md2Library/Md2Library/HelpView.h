// static: Views
//
//  HelpView.h
//  TariffCalculator
//
//  Created by Uni Münster on 30.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "View.h"
#import "EventHandler.h"

@interface HelpView : View <EventHandlerPopoverDelegate>
{
    UILabel *helpTextLabel;
    
    UINavigationBar *navigationBar;
    UINavigationItem *navigationBarItem;
    UIBarButtonItem *backButton;
    
    EventHandler *popoverEventHandler;
}

-(void) setHelpText: (NSString *) text;

@end