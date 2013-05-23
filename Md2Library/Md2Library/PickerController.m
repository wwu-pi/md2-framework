// static: Controllers
//
//  PickerController.m
//  TariffCalculator
//
//  Created by Uni Münster on 01.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "PickerController.h"
#import "PickerView.h"

@interface PickerController ()
@end

@implementation PickerController

-(id) init
{
    self = [super init];
    if (self)
    {
        contentView = [[PickerView alloc] init];
        [self loadView];
    }
    return self;
}

-(void) setComboboxWidget: (ComboboxWidget *) widget
{
    [((PickerView *) contentView) setComboboxWidget: widget];
}

@end