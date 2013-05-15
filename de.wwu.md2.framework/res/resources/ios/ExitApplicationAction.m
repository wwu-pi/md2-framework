// static: Actions
//
//  ExitApplicationAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 17.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ExitApplicationAction.h"

@implementation ExitApplicationAction

+(void) performAction: (ExitApplicationEvent *) event
{
    ExitApplicationEvent *_event = (ExitApplicationEvent *) event;
    [_event.controller persistData];
    [[NSUserDefaults standardUserDefaults] synchronize];
    exit(0);
}

@end