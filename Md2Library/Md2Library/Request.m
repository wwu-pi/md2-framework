// static: Requests
//
//  Request.m
//  TariffCalculator
//
//  Created by Uni Münster on 05.07.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Request.h"
#import "AppData.h"

@implementation Request

@synthesize dataObject;

-(void) execute
{
    [self doesNotRecognizeSelector:_cmd];
}

-(BOOL) isModelVersionValid
{
    NSError* error;
    NSURL *modelVersionURL = [NSURL URLWithString: [NSString stringWithFormat: @"%@/md2_model_version/is_valid?version=%@", remoteURL.description, [AppData modelVersion]]];
    NSData* data = [NSData dataWithContentsOfURL: modelVersionURL];
    NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: &error];
    
    return [[jsonData objectForKey: @"isValid"] isEqualToString: @"true"];
}

-(NSString *) getDataObjectPath
{
    NSString *datObjName = [[NSString stringWithString: dataObjectName] substringFromIndex: 1];
    NSString *start = [[dataObjectName substringToIndex: 1] lowercaseString];
    return [start stringByAppendingString: [datObjName stringByReplacingOccurrencesOfString: @"Entity" withString: @""]];
}

@end