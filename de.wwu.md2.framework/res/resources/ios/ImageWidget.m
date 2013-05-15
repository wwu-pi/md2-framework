// static: Widgets
//
//  ImageWidget.m
//  TariffCalculator
//
//  Created by Uni Münster on 01.09.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ImageWidget.h"

@implementation ImageWidget

@synthesize imageName;

-(id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    if (self)
        [self loadWidget];
    return self;
}

-(void) loadWidget
{
    [super loadWidget];
    [self initializeTriggers];
    [self setFrame: ButtonFrame];
}

-(void) setFrame: (CGRect) frame
{
    image = [UIImage imageNamed: imageName];
    imageView = [[UIImageView alloc] initWithFrame: ImageFrame(image)];
    imageView.image = image;
    
    [super setFrame: ImageWidgetFrame(frame,imageView)];
    [self addSubview: imageView];
}

-(void) setData: (NSString *) _data {}

@end