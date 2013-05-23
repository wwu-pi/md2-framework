// static: Actions
//
//  Action.h
//  TariffCalculator
//
//  Created by Uni Münster on 17.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "AppData.h"

@interface Action : NSObject
{
    Event *event;
}

@property (retain, nonatomic) Event *event;

+(id) action;
+(id) actionWithEvent: (Event *) _event;
+(void) performAction;
+(void) performAction: (Event *) event;
+(void) performCustomAction;

@end