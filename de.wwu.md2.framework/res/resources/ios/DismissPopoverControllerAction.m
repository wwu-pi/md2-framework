// static: Actions
//
//  DismissPopoverControllerAction.m
//  TariffCalculator
//
//  Created by Uni Münster on 17.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "DismissPopoverControllerAction.h"

@implementation DismissPopoverControllerAction

+(void) performAction: (Event *) event
{
    if (isPad)
        [[AppData popoverController] dismissPopoverAnimated: YES];
    else if (isPhone)
        [[AppData currentController] dismissModalViewControllerAnimated: YES];
}

@end