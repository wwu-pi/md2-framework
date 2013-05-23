// static: Views
//
//  EventTrigger.m
//  TariffCalculator
//
//  Created by Uni Münster on 24.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "EventTrigger.h"
#import "EventHandler.h"

@implementation UIView (EventTrigger)

#pragma mark Event Binding Methods

-(void) initializeTriggers
{
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(leftSwipeDetected:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer: leftSwipeGestureRecognizer];
    
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(rightSwipeDetected:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer: rightSwipeGestureRecognizer];
}

-(NSString *) getIdentifier
{
    if ([[self class] isSubclassOfClass: [Widget class]])
        return ((Widget *) self).identifier;
    else if ([[self class] isSubclassOfClass: [Layout class]])
        return ((Layout *) self).identifier;
    else if ([[self class] isSubclassOfClass: [View class]])
        return ((View *) self).identifier;
    return @"";
}

#pragma mark UIView Methods

-(void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (![[self getIdentifier] isEqualToString: @""])
        [[EventHandler instance] eventTriggered: [ViewEvent eventWithIdentifier: [self getIdentifier] eventType: OnTouch]];
    else
        [super touchesBegan: touches withEvent: event];
}

#pragma mark Action Methods

-(IBAction) buttonTouched: (id) sender
{
    if (![[self getIdentifier] isEqualToString: @""])
        [[EventHandler instance] eventTriggered: [ViewEvent eventWithIdentifier: [self getIdentifier] eventType: OnTouch]];
}

-(IBAction) leftSwipeDetected: (id) sender
{
    if (![[self getIdentifier] isEqualToString: @""])
        [[EventHandler instance] eventTriggered: [ViewEvent eventWithIdentifier: [self getIdentifier] eventType: LeftSwipe]];
}

-(IBAction) rightSwipeDetected: (id) sender
{
    if (![[self getIdentifier] isEqualToString: @""])
        [[EventHandler instance] eventTriggered: [ViewEvent eventWithIdentifier: [self getIdentifier] eventType: RightSwipe]];
}

@end