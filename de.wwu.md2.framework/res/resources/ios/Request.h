// static: Requests
//
//  Request.h
//  TariffCalculator
//
//  Created by Uni Münster on 05.07.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Request : NSObject
{
    NSManagedObject *dataObject;
    NSString *dataObjectName;
    NSURL *remoteURL;
}

@property (readonly, nonatomic) NSManagedObject *dataObject;

-(void) execute;
-(NSString *) getDataObjectPath;

@end