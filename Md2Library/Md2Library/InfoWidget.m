// static: Widgets
//
//  InfoWidget.m
//  TariffCalculator
//
//  Created by Uni Münster on 05.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "InfoWidget.h"
#import "Widget.h"

@implementation Widget (InfoWidget)

-(id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        infoButtonEventHandler = [EventHandler instance];
        [infoButtonEventHandler setEventHandlerInfoButtonDelegate: self];
    }
    return self;
}

-(void) loadInfoButton
{
    if (hasInfoButton)
    {
        UIImage* infoButtonImage = [UIImage imageNamed:@"information.png"];
        infoButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [infoButton setImage: infoButtonImage forState: UIControlStateNormal];
        infoButton.frame = InfoButtonFrame(self.frame);
        [infoButton setEnabled: YES];
        [infoButton addTarget: self action: @selector(infoButtonClicked:) forControlEvents: UIControlEventTouchDown];
        [self addSubview: infoButton];
    }
}

#pragma mark EventHandlerInfoButtonDelegate Methods

-(void) infoWidgetButtonClicked: (InfoButtonClickedEvent *) event
{
    [((EventHandler *) infoButtonEventHandler) infoWidgetButtonClicked: event];
}

#pragma mark - Actions

-(IBAction) infoButtonClicked: (id) sender
{
    [self infoWidgetButtonClicked: [InfoButtonClickedEvent  eventWithSender: sender infoText: self.infoText]];
}

@end