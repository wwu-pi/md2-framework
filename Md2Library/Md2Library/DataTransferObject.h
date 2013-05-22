// static: DTOs
//
//  DataTransferObject.h
//  TariffCalculator
//
//  Created by Uni Münster on 08.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataTransferObject : NSManagedObject

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSNumber * identifier;

@end