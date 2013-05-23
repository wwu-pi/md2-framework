// static: Events
//
//  InfoButtonClickedEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 04.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "InfoButtonClickedEvent.h"

@implementation InfoButtonClickedEvent

@synthesize sender, infoText;

+(id) eventWithSender: (id) _sender infoText: (NSString *) _infoText
{
    InfoButtonClickedEvent *event = [[InfoButtonClickedEvent alloc] init];
    event.sender = _sender;
    event.infoText = _infoText;
    return event;
}

@end