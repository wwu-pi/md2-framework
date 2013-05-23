// static: Controllers
//
//  HelpViewController.h
//  Tarifrechner
//
//  Created by Uni Münster on 08.05.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "HelpController.h"
#import "HelpView.h"

@interface HelpController ()
@end

@implementation HelpController

-(id) init
{
    self = [super init];
    if (self)
    {
        contentView = [[HelpView alloc] init];
        [self loadView];
    }
    return self;
}

-(void) setHelpText: (NSString *) text
{
    [((HelpView *) contentView) setHelpText: text];
}

@end