// static: Validators
//
//  RemoteValidator.h
//  TariffCalculator
//
//  Created by Uni Münster on 05.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Validator.h"
#import "ContentProvider.h"

@interface RemoteValidator : Validator
{
    NSString *name;
    NSString *remoteURL;
    ContentProvider *contentProvider;
    NSDictionary *attributes;
}

-(id) initWithName: (NSString *) name remoteURL: (NSString *) _remoteURL contentProvider: (ContentProvider *) _contentProvider attributes: (NSDictionary *) _attributes;

@end