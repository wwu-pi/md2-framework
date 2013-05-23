// static: Utility
//
//  Utilities.h
//  TariffCalculator
//
//  Created by Uni Münster on 01.07.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import <CoreData/CoreData.h>

// Category for ManagedObjects
@interface NSManagedObject (Utilities)

-(BOOL) containsAttributeForKey: (NSString *) key;
-(NSManagedObject *) setAttributesByJSONData: (NSDictionary *) keyedValues;
-(NSDictionary *) getDictionary;
-(void) revertLocalChanges;

@end