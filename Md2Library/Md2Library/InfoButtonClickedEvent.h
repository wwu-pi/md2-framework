// static: Events
//
//  InfoButtonClickedEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 04.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"

@interface InfoButtonClickedEvent : Event
{
    id sender;
    NSString *infoText;
}

@property (retain, nonatomic) id sender;
@property (retain, nonatomic) NSString *infoText;

+(id) eventWithSender: (id) _sender infoText: (NSString *) _infoText;

@end