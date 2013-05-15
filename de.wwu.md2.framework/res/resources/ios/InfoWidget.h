// static: Widgets
//
//  InfoWidget.h
//  TariffCalculator
//
//  Created by Uni Münster on 05.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Widget.h"
#import "EventHandler.h"

@interface Widget  (InfoWidget) <EventHandlerInfoButtonDelegate>
-(void) loadInfoButton;
@end