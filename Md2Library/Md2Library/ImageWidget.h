// static: Widgets
//
//  ImageWidget.h
//  TariffCalculator
//
//  Created by Uni Münster on 01.09.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Widget.h"

@interface ImageWidget : Widget
{
    NSString *imageName;
    UIImage *image;
    UIImageView *imageView;
}

@property (retain, nonatomic) NSString *imageName;

@end