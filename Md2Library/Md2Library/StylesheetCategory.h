// static: Style
//
//  NSObject+Stylesheet.h
//  TariffCalculator
//
//  Created by Uni Münster on 20.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Stylesheet.h"

@interface NSObject (Style)

@property (retain, nonatomic) Stylesheet *stylesheet;

-(void) styleByIdentifier: (NSString *) identifier;
-(void) setStyle: (Stylesheet *) stylesheet;
-(id) style;

@end