// static: Views
//
//  HelpView.m
//  TariffCalculator
//
//  Created by Uni Münster on 30.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "HelpView.h"
#import "AppDelegate.h"
#import "FlowLayout.h"

@implementation HelpView

-(id) init
{
    self = [super init];
    if (self)
    {
        popoverEventHandler = [EventHandler instance];
        [popoverEventHandler setEventHandlerPopoverDelegate: self];
        
        hasContentInsets = YES;
        identifier = @"help";
    }
    return self;
}

-(void) loadView
{
    [super loadView];
    contentView.frame = HelpPickerViewFrame;
    
    navigationBar = [[UINavigationBar alloc] initWithFrame: NavigationBarFrame];
    navigationBar.tintColor = [UIColor blackColor];
    NSString *key = [NSString stringWithFormat: @"NB_%@", identifier];
    navigationBarItem = [[UINavigationItem alloc] initWithTitle: LocalizedKeyString(key)];
    
    navigationBar.frame = HelpNavigationBarFrame(navigationBar.frame);
    backButton = [[UIBarButtonItem alloc] initWithTitle: LocalizedKeyString(@"BT_done") style: UIBarButtonItemStylePlain target: self action: @selector(doneButtonClicked:)];
    navigationBarItem.leftBarButtonItem = backButton;
    [navigationBar pushNavigationItem: navigationBarItem animated: NO];
    
    helpTextLabel = [[UILabel alloc] initWithFrame: HelpTextLabelFrame];
    helpTextLabel.textAlignment = UITextAlignmentLeft;
    helpTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    helpTextLabel.numberOfLines = 0;
    helpTextLabel.minimumFontSize = 10;
    helpTextLabel.font = [UIFont systemFontOfSize: 15];
    
    [self addSubview: navigationBar];
    [contentView addSubview: helpTextLabel];
}

-(void) setHelpText:(NSString *) text
{
    [helpTextLabel setText: text];
    [helpTextLabel sizeToFit];
}

#pragma mark Action Methods

-(IBAction) doneButtonClicked: (id) sender
{
    [self dismissPopoverController];
}

#pragma mark EventHandlerPickerDelegate Methods

-(void) dismissPopoverController
{
    [popoverEventHandler dismissPopoverController];
}

@end